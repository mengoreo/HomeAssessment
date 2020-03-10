//
//  Option+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension Option {

    @nonobjc public class func fetch() -> NSFetchRequest<Option> {
        let request = NSFetchRequest<Option>(entityName: "Option")
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var from_val: Double
    @NSManaged public var index: Int32
    @NSManaged public var optionDescription: String
    @NSManaged public var suggestion: String
    @NSManaged public var to_val: Double
    @NSManaged public var uuid: UUID
    @NSManaged public var vote: Double
    @NSManaged public var question: Question

}
