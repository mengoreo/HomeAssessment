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

    enum CodingKeys: String, CodingKey {
        case dateCreated,
        dateUpdated,
        index,
        measurable,
        name,
        uuid,
        options,
        standard
    }
}
// MARK: - NSSecureCoding
extension Question {
    public func encode(with encoder: NSCoder) {
        print("** encoding questions")
        encoder.encode(dateCreated, forKey: CodingKeys.dateCreated.rawValue)
        encoder.encode(dateUpdated, forKey: CodingKeys.dateUpdated.rawValue)
        encoder.encode(index, forKey: CodingKeys.index.rawValue)
        encoder.encode(measurable, forKey: CodingKeys.measurable.rawValue)
        encoder.encode(name, forKey: CodingKeys.name.rawValue)
        encoder.encode(uuid, forKey: CodingKeys.uuid.rawValue)
        encoder.encode(options, forKey: CodingKeys.options.rawValue)
        encoder.encode(standard, forKey: CodingKeys.standard.rawValue)
    }
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
