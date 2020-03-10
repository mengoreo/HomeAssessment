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

}
