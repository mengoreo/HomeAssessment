//
//  ThumbnailImage+CoreDataClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import UIKit
import CoreData

@objc(ThumbnailImage)
public class ThumbnailImage: NSManagedObject, Identifiable, NSSecureCoding {
    required convenience public init?(coder: NSCoder) {
        print("** decoding ThumbnailImage")
        self.init(context: CoreDataHelper.stack.context)
        uuid = coder.decodeObject(forKey: CodingKeys.uuid.rawValue) as? UUID
        imageData = coder.decodeObject(forKey: CodingKeys.imageData.rawValue) as? Data
        dateCreated = coder.decodeObject(forKey: CodingKeys.dateCreated.rawValue) as? Date
        questionID = coder.decodeObject(forKey: CodingKeys.questionID.rawValue) as? UUID
        originalImage = coder.decodeObject(forKey: CodingKeys.originalImage.rawValue) as? OriginalImage
//        assessment = coder.decodeObject(forKey: CodingKeys.assessment.rawValue) as? Assessment
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func performCreate(for questionID: UUID? = nil,
                             in assessment: Assessment? = nil,
                             with image: UIImage,
                             completionHandler: @escaping (Error?, ThumbnailImage?) -> Void) {
        let convertQueue = dispatch_queue_concurrent_t(label: "convertQueue") // MARK: - 并行线程处理
        
        convertQueue.async {
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                completionHandler(NSError(domain: "ImageConvertion", code: 88, userInfo: ["detail" : "error while converting to imageData"]), nil)
                return
            }

            guard let thumbnailData  = image.jpegData(compressionQuality: 0.25) else {
                completionHandler(NSError(domain: "ImageConvertion", code: 88, userInfo: ["detail" : "error while converting to thumbnailData"]), nil)
                return
            }
            // MARK: - 创建 ThumbnailImage 实例，并与 assessment 关联
            let createdThumbnail = create(for: questionID, in: assessment, imageData: imageData, thumbnailData: thumbnailData)
            
            completionHandler(nil, createdThumbnail)

        }
    }
    
    class func create(for questionID: UUID? = nil, in assessment: Assessment? = nil, imageData: Data, thumbnailData: Data) -> ThumbnailImage {

        print("creating thumbnail for question \(questionID as Any), assessment: \(assessment as Any)")
        let newThumbnailImage = ThumbnailImage(context: CoreDataHelper.stack.context)
        newThumbnailImage.assessment = assessment
        newThumbnailImage.dateCreated = Date()
        newThumbnailImage.uuid = UUID()
        newThumbnailImage.imageData = thumbnailData
        let newOriginalImage = OriginalImage(context: CoreDataHelper.stack.context)
        newOriginalImage.imageData = imageData
        newThumbnailImage.originalImage = newOriginalImage
        newThumbnailImage.questionID = questionID
        return newThumbnailImage
    }
    
    func delete() {
        CoreDataHelper.stack.context.delete(self)
    }
    
}

extension ThumbnailImage {
    var uiImage: UIImage {
        get {
            if let data = self.imageData {
                print("thumbnail data", data)
                return UIImage(data: data) ?? UIImage()
            }
            return UIImage()
        }
    }
    func getUIImage(completionHandler: @escaping (_ image: UIImage) -> Void) {
        var result = UIImage()
        while result.pngData() == nil {
            result = uiImage
        }
        completionHandler(result)
    }
}
