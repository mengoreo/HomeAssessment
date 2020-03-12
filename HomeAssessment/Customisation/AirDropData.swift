//
//  AirDropData.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import UIKit

class AirDropData: NSObject, UIActivityItemSource {
    
    var data: Data
    var placeholder: String
    
    init(with data: Data, placeholder: String) {
        self.data = data
        self.placeholder = placeholder + ".haassessment"
        super.init()
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                thumbnailImageForActivityType activityType: UIActivity.ActivityType?,
                                suggestedSize size: CGSize) -> UIImage? {
            return UIImage(named: "AppIcon")
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return URL(fileURLWithPath: placeholder)
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .airDrop {
            return data
        }
        return nil
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "com.mengoreo.HA.assessment"
    }
    
}
