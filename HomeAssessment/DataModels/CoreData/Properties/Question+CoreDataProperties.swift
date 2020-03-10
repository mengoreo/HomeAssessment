//
//  Question+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetch() -> NSFetchRequest<Question> {
        let request = NSFetchRequest<Question>(entityName: "Question")
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var index: Int32
    @NSManaged public var measurable: Bool
    @NSManaged public var name: String
    @NSManaged public var uuid: UUID
    @NSManaged public var options: Set<Option>?
    @NSManaged public var standard: Standard

}

// MARK: Generated accessors for options
extension Question {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: Option)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: Option)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}
