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
    
    enum CodingKeys: String, CodingKey {
        case dateCreated,
        dateUpdated,
        name,
        phone,
        uuid,
        assessment
    }
}
// MARK: - NSSecureCoding
extension Contact {
    public func encode(with encoder: NSCoder) {
        print("** ecoding Contact")
        encoder.encode(dateCreated, forKey: CodingKeys.dateCreated.rawValue)
        encoder.encode(dateUpdated, forKey: CodingKeys.dateUpdated.rawValue)
        encoder.encode(name, forKey: CodingKeys.name.rawValue)
        encoder.encode(phone, forKey: CodingKeys.phone.rawValue)
        encoder.encode(uuid, forKey: CodingKeys.uuid.rawValue)
        encoder.encode(assessment, forKey: CodingKeys.assessment.rawValue)
        
    }
}
