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
public class ThumbnailImage: NSManagedObject {
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func performCreate(for questionID: UUID? = nil,
                             in assessment: Assessment? = nil,
                             with image: UIImage,
                             completionHandler: @escaping (Error?, ThumbnailImage?) -> Void) {
        let convertQueue = dispatch_queue_concurrent_t(label: "convertQueue")
        print("*** performCreate")
        
        convertQueue.async {
            print("** converting")
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                // handle failed conversion
                
                print("jpg error")
                completionHandler(NSError(domain: "ImageConvertion", code: 88, userInfo: ["detail" : "error while converting to imageData"]), nil)
                return
            }

            guard let thumbnailData  = image.jpegData(compressionQuality: 0.25) else {
                // handle failed conversion
                print("jpg error")
                completionHandler(NSError(domain: "ImageConvertion", code: 88, userInfo: ["detail" : "error while converting to thumbnailData"]), nil)
                return
            }
            let createdThumbnail = create(for: questionID, in: assessment, imageData: imageData, thumbnailData: thumbnailData)
            
            completionHandler(nil, createdThumbnail)

        }
    }
    
    class func create(for questionID: UUID? = nil, in assessment: Assessment? = nil, imageData: Data, thumbnailData: Data) -> ThumbnailImage {

        print("creating thumbnail for \(questionID as Any)")
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
                print("empty iamge: \(UIImage().pngData())")
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
