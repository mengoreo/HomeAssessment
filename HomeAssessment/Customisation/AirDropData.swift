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
    
    // MARK: - 接收方的展示
    func activityViewController(_ activityViewController: UIActivityViewController,
                                thumbnailImageForActivityType activityType: UIActivity.ActivityType?,
                                suggestedSize size: CGSize) -> UIImage? {
        switch shareType {
        case .haassessment:
            return UIImage(named: "icon")
        case .pdf:
            return UIImage(systemName: "doc")
        }
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        // MARK: - For showing while shareing
        return URL(fileURLWithPath: placeholder)
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return data
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        print("dataTypeIdentifierForActivityType")
        return "com.mengoreo.HA.\(shareType.stringValue)"
    }
    
}
