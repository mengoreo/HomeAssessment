//
//  OriginalImage+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension OriginalImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OriginalImage> {
        return NSFetchRequest<OriginalImage>(entityName: "OriginalImage")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var thumbnail: ThumbnailImage

}
