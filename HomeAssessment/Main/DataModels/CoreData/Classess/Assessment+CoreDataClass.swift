//
//  Assessment+CoreDataClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData
import CoreLocation
import UIKit

@objc(Assessment)
public class Assessment: NSManagedObject, Identifiable, NSSecureCoding {
    
    required convenience public init?(coder: NSCoder) {
        print("** decoding Assessment")
        self.init(context: CoreDataHelper.stack.context)
        address = coder.decodeObject(forKey: CodingKeys.address.rawValue) as? CLPlacemark
        dateCreated = coder.decodeObject(forKey: CodingKeys.dateCreated.rawValue) as! Date
        dateUpdated = coder.decodeObject(forKey: CodingKeys.dateUpdated.rawValue) as? Date
        mapPreviewNeedsUpdate = coder.decodeBool(forKey: CodingKeys.mapPreviewNeedsUpdate.rawValue)
        progress = coder.decodeDouble(forKey: CodingKeys.progress.rawValue)
        remarks = coder.decodeObject(forKey: CodingKeys.remarks.rawValue) as! String
        selectedOptions = coder.decodeObject(forKey: CodingKeys.selectedOptions.rawValue) as! [UUID: UUID]
        uuid = coder.decodeObject(forKey: CodingKeys.uuid.rawValue) as! UUID
        contacts = coder.decodeObject(forKey: CodingKeys.contacts.rawValue) as? Set<Contact>
        elders = coder.decodeObject(forKey: CodingKeys.elders.rawValue) as? Set<Elder>
        standard = coder.decodeObject(forKey: CodingKeys.assessmentToStandard.rawValue) as? Standard
        user = coder.decodeObject(forKey: CodingKeys.user.rawValue) as! UserSession
        capturedImages = coder.decodeObject(forKey: CodingKeys.capturedImages.rawValue) as? Set<ThumbnailImage>
        mapPreview = coder.decodeObject(forKey: CodingKeys.mapPreview.rawValue) as? ThumbnailImage
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    
    class func createUnassociated(with standard: Standard?, remarks: String, address: CLPlacemark?, in context: NSManagedObjectContext) -> Assessment {
        
        
        let newAssessment = Assessment(context: context)
//        newAssessment.managedObjectContext = assessmentContext
        newAssessment.uuid = UUID()
        newAssessment.dateCreated = Date()
        newAssessment.dateUpdated = Date()
        newAssessment.progress = 0
        newAssessment.remarks = remarks
        newAssessment.address = address
        newAssessment.mapPreviewNeedsUpdate = address != nil
        newAssessment.standard = standard
//            newAssessment.user = user
        newAssessment.selectedOptions = [:]
        return newAssessment
        
    }
    class func create(for user: UserSession, with standard: Standard?, remarks: String, address: CLPlacemark?) -> Assessment {

        let newAssessment = Assessment(context: CoreDataHelper.stack.context)
        newAssessment.uuid = UUID()
        newAssessment.dateCreated = Date()
        newAssessment.dateUpdated = Date()
        newAssessment.progress = 0
        newAssessment.remarks = remarks
        newAssessment.address = address
        newAssessment.mapPreviewNeedsUpdate = address != nil
        newAssessment.standard = standard
        newAssessment.user = user
        newAssessment.selectedOptions = [:]
        return newAssessment
    }
    
    class func all() -> [Assessment] {
        return CoreDataHelper.stack.fetch(self.fetch())
    }
    
    class func clear() {
        for a in all() {
            a.delete()
        }
    }
    class func alreadyHas(_ remarks: String) -> Bool {
        return findByRemarks(with: remarks) != nil
    }
    class func findByRemarks(with value: String) -> Assessment? {
        
        let request = fetch()
        let predicate = NSPredicate(format: "remarks == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    class func findByID(with value: UUID) -> Assessment? {
        let request = fetch()
        let predicate = NSPredicate(format: "uuid == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    func update(preview: UIImage?, completionHandler: @escaping (_ saved: Bool) -> Void = {_ in}) {
        if let image = preview {
            ThumbnailImage.performCreate(with: image) { (error, thumbnail) in
                guard error == nil else {
                    fatalError((error! as NSError).userInfo["detail"] as! String)
                }
                self.mapPreview = thumbnail!
                self.mapPreviewNeedsUpdate = false
//                CoreDataHelper.stack.save()
                completionHandler(true)
            }
        } else {
            completionHandler(false)
        }
    }
    
    func update(_ force: Bool = false,
                remarks: String? = nil,
                address: CLPlacemark? = nil,
                preview: UIImage? = nil,
                progress: Double? = nil,
                standard: Standard? = nil) {
        var updated = force
        if let remarks = remarks, remarks != self.remarks {
            print("** update remarks")
            self.remarks = remarks
            updated = true
        }
        if let progress = progress, progress != self.progress {
            print("** update progress")
            self.progress = progress
            updated = true
        }
        if let address = address {
            if self.address == nil || !self.address!.isEqualTo(address){
                print("** update address")
                self.address = address
                self.mapPreviewNeedsUpdate = true
                updated = true
            }
        }
        if let image = preview, image != self.mapPreview?.uiImage {
            ThumbnailImage.performCreate(with: image) { (error, thumbnail) in
                guard error == nil else {
                    fatalError((error! as NSError).userInfo["detail"] as! String)
                }
                self.mapPreview = thumbnail!
                self.mapPreviewNeedsUpdate = false
//                CoreDataHelper.stack.save()
            }
        }
        if let standard = standard, standard != self.standard {
            print("** update standard")
            self.standard = standard
            updated = true
        }
        if updated {
            print("** update date")
            self.dateUpdated = Date()
        }
        
        if self.progress == 1 {
            uploadToServer()
        }
        print("** updated assessment")
    }
    
    func delete() {
        print(self, "deleting")
        CoreDataHelper.stack.context.delete(self)
//        CoreDataHelper.stack.save()
    }
    func getElders() -> [Elder] {
        Elder.all().filter{$0.assessment == self}
//        elders?.sorted(by: {$0.dateUpdated.timeIntervalSince1970 > $1.dateUpdated.timeIntervalSince1970}) ?? []
//        if self.elders != nil {
//            let request = Elder.fetch()
//            request.predicate = NSPredicate(format: "SELF IN %@", self.elders!)
//            return CoreDataHelper.stack.fetch(request)
//        }
//        return []
//        return Elder.all().filter{!$0.isDeleted && $0.assessment == self} // MARK: will iclude all
    }
    func getContacts() -> [Contact] {
        Contact.all().filter{$0.assessment == self}
//        contacts?.sorted(by: {$0.dateUpdated.timeIntervalSince1970 > $1.dateUpdated.timeIntervalSince1970}) ?? []
//        self.managedObjectContext.fet
//        print("*** geting contacts")
//        Contact.all().filter{!$0.isDeleted && $0.assessment == self}
//        do {
//            try print(managedObjectContext?.fetch(Contact.fetch()))
//        } catch {
//            print("error while getting contacts")
//        }
        
//        print(Contact.all())
//        return []
//        if self.contacts != nil {
//            let request = Contact.fetch()
//            request.predicate = NSPredicate(format: "SELF IN %@", self.contacts!)
//            return CoreDataHelper.stack.fetch(request)
//        }
//        return []
//        return Contact.all().filter{$0.assessment == self}
    }
    func getThumbnails(for questionID: UUID) -> [ThumbnailImage] {
        print("getThumbnails in assessment")
        if let capturedImages = self.capturedImages {
            let request = ThumbnailImage.fetch()
            request.predicate = NSPredicate(format: "SELF IN %@", capturedImages)
            let result = CoreDataHelper.stack.fetch(request).filter{$0.questionID == questionID}
            if !result.isEmpty {
                return result.sorted(by: {$0.dateCreated! > $1.dateCreated!})
            }
        }
//        var result: [ThumbnailImage] = self.capturedImages?.first.map{$0 ?? nil} ?? []
//        print("result", result, "question", questionID)
//        print("captured images", self.capturedImages)
        
        return []
    }
    
    func getAllThumbnails() -> [ThumbnailImage] {
//        var result = Array(self.capturedImages ?? []) as [ThumbnailImage]
//        if !result.isEmpty {
//            result.sort(by: {$0.uuid!.hashValue > $1.uuid!.hashValue})
//        }
//        return result
        return []
    }
    
    func isValid() -> Bool {
        return
            !self.remarks.isEmpty
                &&
                !self.getElders().isEmpty
                &&
                !self.getContacts().isEmpty
                &&
                self.address != nil
    }
    
    func uploadToServer() {
        APIDataManager.fetch(.assessments, with: user.token!, completionHandler: handleAssessmentResponseFromServer)
    }
    
    
    private func handleAssessmentResponseFromServer(data: Data, response: URLResponse, error: Error?) {
        if error != nil {
            print("*** error in handle")
            return
        }
        guard let assessments = try? JSONDecoder().decode([AssessmentFromServer].self, from: data) else {
            fatalError("questions decode error")
        }
        
        for assessment in assessments {
            if assessment.id == self.uuid && different(from: assessment){
                APIDataManager.post(.assessments, with: user.token!, completionHandler: handleResponseForPost)
                break
            }
        }
    }
    private func handleResponseForPost(data: Data, response: URLResponse, error: Error?) {
        
    }
    private func different(from: AssessmentFromServer) -> Bool {
        return from.id == self.uuid
    }
}


struct AssessmentFromServer: Codable {
    var id: UUID
    var remarks: String
    var report: Report
    var latitude: Double
    var longtitude: Double
    
    
}

struct Report: Codable {
    var description: String
    
    func isEqual(to: Report) -> Bool {
        return to.description == description
    }
}
