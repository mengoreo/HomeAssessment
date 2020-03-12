//
//  OriginalImage+CoreDataClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import UIKit
import CoreData

@objc(OriginalImage)
public class OriginalImage: NSManagedObject, Identifiable, NSSecureCoding {
    required convenience public init?(coder: NSCoder) {
        print("** decoding OriginalImage")
        self.init(context: CoreDataHelper.stack.context)
        imageData = coder.decodeObject(forKey: CodingKeys.imageData.rawValue) as? Data
//        thumbnail = coder.decodeObject(forKey: CodingKeys.thumbnail.rawValue) as! ThumbnailImage
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
}
extension OriginalImage {
    var uiImage: UIImage {
        get {
            if let data = imageData {
                return UIImage(data: data) ?? UIImage()
            }
            return UIImage()
        }
    }
}
