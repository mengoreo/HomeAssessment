//
//  Elder+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension Elder {

    @nonobjc public class func fetch() -> NSFetchRequest<Elder> {
        let request = NSFetchRequest<Elder>(entityName: "Elder")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var heightInCM: Int32
    @NSManaged public var name: String
    @NSManaged public var status: String
    @NSManaged public var uuid: UUID
    @NSManaged public var assessment: Assessment
    
    enum CodingKeys: String, CodingKey {
        case dateCreated,
        dateUpdated,
        heightInCM,
        name,
        status,
        uuid,
        assessment
    }
}
// MARK: - NSSecureCoding
extension Elder {
    public func encode(with encoder: NSCoder) {
        print("** ecoding Elder")
        encoder.encode(dateCreated, forKey: CodingKeys.dateCreated.rawValue)
        encoder.encode(dateUpdated, forKey: CodingKeys.dateUpdated.rawValue)
        encoder.encode(heightInCM, forKey: CodingKeys.heightInCM.rawValue)
        encoder.encode(status, forKey: CodingKeys.status.rawValue)
        encoder.encode(name, forKey: CodingKeys.name.rawValue)
        encoder.encode(uuid, forKey: CodingKeys.uuid.rawValue)
        encoder.encode(assessment, forKey: CodingKeys.assessment.rawValue)
    }
}
