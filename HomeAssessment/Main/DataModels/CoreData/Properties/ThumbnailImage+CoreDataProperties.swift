//
//  ThumbnailImage+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension ThumbnailImage {

    @nonobjc public class func fetch() -> NSFetchRequest<ThumbnailImage> {
        let request = NSFetchRequest<ThumbnailImage>(entityName: "ThumbnailImage")
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var questionID: UUID?
    @NSManaged public var originalImage: OriginalImage?
    @NSManaged public var assessment: Assessment?

    enum CodingKeys:String, CodingKey {
        case uuid,
        imageData,
        dateCreated,
        questionID,
        originalImage,
        assessment
        
    }
}

// MARK: - NSSecureCoding
extension ThumbnailImage {
    public func encode(with encoder: NSCoder) {
        print("** encoding thumbnail")
        encoder.encode(uuid, forKey: CodingKeys.uuid.rawValue)
        encoder.encode(imageData, forKey: CodingKeys.imageData.rawValue)
        encoder.encode(dateCreated, forKey: CodingKeys.dateCreated.rawValue)
        encoder.encode(questionID, forKey: CodingKeys.questionID.rawValue)
        encoder.encode(originalImage, forKey: CodingKeys.originalImage.rawValue)
        encoder.encode(assessment, forKey: CodingKeys.assessment.rawValue)
    }
}
