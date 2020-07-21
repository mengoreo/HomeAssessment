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

    enum CodingKeys: String, CodingKey {
        case dateCreated,
        dateUpdated,
        from_val,
        index,
        optionDescription,
        suggestion,
        to_val,
        uuid,
        vote,
        question
    }
}
// MARK: - NSSecureCoding
extension Option {
    public func encode(with encoder: NSCoder) {
        print("** ecoding Option")
        encoder.encode(dateCreated, forKey: CodingKeys.dateCreated.rawValue)
        encoder.encode(dateUpdated, forKey: CodingKeys.dateUpdated.rawValue)
        encoder.encode(from_val, forKey: CodingKeys.from_val.rawValue)
        encoder.encode(index, forKey: CodingKeys.index.rawValue)
        encoder.encode(optionDescription, forKey: CodingKeys.optionDescription.rawValue)
        encoder.encode(suggestion, forKey: CodingKeys.suggestion.rawValue)
        encoder.encode(to_val, forKey: CodingKeys.to_val.rawValue)
        encoder.encode(uuid, forKey: CodingKeys.uuid.rawValue)
        encoder.encode(vote, forKey: CodingKeys.vote.rawValue)
        encoder.encode(question, forKey: CodingKeys.question.rawValue)
    }
}
