//
//  Contact+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetch() -> NSFetchRequest<Contact> {
        let request = NSFetchRequest<Contact>(entityName: "Contact")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var uuid: UUID
    @NSManaged public var assessment: Assessment

}
