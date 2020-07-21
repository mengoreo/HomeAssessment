//
//  AppStatus+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension AppStatus {

    @nonobjc public class func fetch() -> NSFetchRequest<AppStatus> {
        let request = NSFetchRequest<AppStatus>(entityName: "AppStatus")
        request.sortDescriptors = [NSSortDescriptor(key: "lastUserName", ascending: true)]
        return request
    }

    @NSManaged public var authorised: Bool
    @NSManaged public var hideTabBar: Bool
    @NSManaged public var lastOpenedTab: Int32
    @NSManaged public var lastUserName: String
    @NSManaged public var lastUserInterface: Int32
    @NSManaged public var readyToSaveCombined: Bool
    
    enum CodingKeys: String, CodingKey {
        case authorised,
        hideTabBar,
        lastOpenedTab,
        lastUserName,
        lastUserInterface
    }
}

// MARK: - NSSecureCoding
extension AppStatus {
    public func encode(with encoder: NSCoder) {
        print("** encoding Appstatus")
        encoder.encode(authorised, forKey: CodingKeys.authorised.rawValue)
        encoder.encode(hideTabBar, forKey: CodingKeys.hideTabBar.rawValue)
        encoder.encode(lastOpenedTab, forKey: CodingKeys.lastOpenedTab.rawValue)
        encoder.encode(lastUserName, forKey: CodingKeys.lastUserName.rawValue)
        encoder.encode(lastUserInterface, forKey: CodingKeys.lastUserInterface.rawValue)
    }
}
