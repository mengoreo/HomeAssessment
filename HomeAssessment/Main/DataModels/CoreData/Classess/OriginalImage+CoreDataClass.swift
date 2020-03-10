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
public class OriginalImage: NSManagedObject {

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
