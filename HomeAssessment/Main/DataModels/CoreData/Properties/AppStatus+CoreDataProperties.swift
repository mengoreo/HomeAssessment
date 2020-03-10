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
    @NSManaged public var lastOpenedTab: Int16
    @NSManaged public var lastUserName: String
    @NSManaged public var lastUserInterface: Int16

}
