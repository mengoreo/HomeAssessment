//
//  ShareDataManager.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import CoreLocation

class ShareDataManager {
    
    static var manager = ShareDataManager()
    
    enum Error: Swift.Error {
        case fileAlreadyExists
        case fileNotExists
        case invalidDirectory
        case writtingFailed
        case readingFailed
    }
    
    var removedOptions = [UUID: Option]()
    
    let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        NotificationCenter.default.addObserver(self, selector: #selector(clearCached), name: .DoneCombineAssessments, object: nil)
    }
    
    
    private func combine(_ inComing: Assessment, with onDevice: Assessment) {
        
        func deleteOptions(for question: Question) {
            let onDeviceOptionID = onDevice.selectedOptions[question.uuid]
            let inComingOptionID = inComing.selectedOptions[question.uuid]
            
            var hasInComingOption = false // flag whether there is options from incoming assessment
            var deleted = 0
            for o in question.options ?? [] {
                print("option:", o.uuid)
                if o.uuid == onDeviceOptionID {
                    o.suggestion = "我"
                } else if o.uuid == inComingOptionID {
                    hasInComingOption = true
                    o.suggestion = inComing.user.name
                } else {
                    o.delete()
                    deleted += 1
                }
            }
            
            if (deleted == question.options?.count ?? 0)
                || !hasInComingOption {
                question.delete()
            }
        }
        let standard = inComing.standard!
        
        if let questions = standard.questions {
            
            for q in questions {
                deleteOptions(for: q)
            }
        }

        inComing.user.delete()
        inComing.delete() // MARK: - delete temp assessment
        
        // MARK: - notify
        clearCached()
        NotificationCenter.default.post(name: .WillCombineAssessments, object: nil, userInfo: [UserInfoKey.combinedStandard: standard, UserInfoKey.onDeviceAssessment: onDevice])
    }
    
    @objc func clearCached() {
        for option in removedOptions.values {
            option.delete()
        }
        removedOptions.removeAll()
    }
    
    func compressAndShare(_ assessment: Assessment) throws -> AirDropData {
        let placeholder = "分享「\(assessment.remarks)」给同事\n" + ".haassessment"
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: assessment, requiringSecureCoding: true)
            let airDropData = AirDropData(with: data, placeholder: placeholder)
            return airDropData
        } catch {
              throw Error.writtingFailed
        }
    }

    func handle(_ url: URL) {
        if url.pathExtension == "haassessment",
            AppStatus.authorised() {
            do {
                let inComing = try read(from: url)
                // MARK: - 判断用户是否是第二次收到此评估
                if let onDevice = UserSession.currentUser.assessments?.filter({$0.uuid == inComing.uuid}).first{
                    combine(inComing, with: onDevice)
                } else {
                    save(inComing)
                }
            } catch {
                fatalError("error opening: \(error)")
            }
        }
    }
    
//    func clearTempFolder() {
//        let tempFolderPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Inbox")
//        do {
//            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath.absoluteString)
//            for filePath in filePaths {
//                try fileManager.removeItem(atPath: tempFolderPath.absoluteString + filePath)
//            }
//        } catch {
//            print("Could not clear temp folder: \(error)")
//        }
//    }
    private func read(from url: URL) throws -> Assessment {
        do {
            let data = try Data(contentsOf: url)
            print("reading:", data)
            guard let assessment = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Assessment else {
                throw Error.readingFailed
            }
            print("unarchived: ", assessment)
            try? fileManager.removeItem(at: url)
            return assessment
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }
    func delete(_ inComing: Assessment) {
        inComing.standard?.delete()
        inComing.delete()
    }
    func save(_ inComing: Assessment) {
        if let questions = inComing.standard!.questions {
            for q in questions {
                print("questions:", questions)
                guard let options = q.options else {
                    fatalError("No option in \(q.name)")
                }
                print("options:", options)
                for o in options {
                    o.question = q
                }
                q.standard = inComing.standard!
            }
        }
        inComing.standard!.user = .currentUser
        
        inComing.user = .currentUser
        CoreDataHelper.stack.save()
    }
    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
}
