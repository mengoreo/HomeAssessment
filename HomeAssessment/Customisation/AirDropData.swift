//
//  AirDropData.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import UIKit

class AirDropData: NSObject, UIActivityItemSource {
    
    let data: Data
    let placeholder: String
    enum FileType: CodingKey {
        case haassessment
        case pdf
    }
    let shareType: FileType
    init(with data: Data, placeholder: String, type: FileType = .haassessment) {
        self.data = data
        self.placeholder = placeholder + "\n.\(type.stringValue)"
        shareType = type
        super.init()
    }
    
    // MARK: - 1
    func activityViewController(_ activityViewController: UIActivityViewController,
                                thumbnailImageForActivityType activityType: UIActivity.ActivityType?,
                                suggestedSize size: CGSize) -> UIImage? {
        // 调整图标到合适大小
        return resizeImage(image: UIImage(named: "pdfPreview")!, targetSize: size)
    }
    // MARK: - 2
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        // 分享文件时展示的文字
        return URL(fileURLWithPath: placeholder)
    }
    // MARK: - 3
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        // 提供分享的数据
        return data
    }
    // MARK: - 4
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        // 分享文件的标识符
        return "com.mengoreo.HA.\(shareType.stringValue)"
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
}
