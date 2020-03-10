//
//  UserSession+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension UserSession {

    @nonobjc public class func fetch() -> NSFetchRequest<UserSession> {
        let request = NSFetchRequest<UserSession>(entityName: "UserSession")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var name: String
    @NSManaged public var token: String
    @NSManaged public var uuid: UUID
    @NSManaged public var assessments: Set<Assessment>?
    @NSManaged public var standards: Set<Standard>?

}

// MARK: Generated accessors for assessments
extension UserSession {

    @objc(addAssessmentsObject:)
    @NSManaged public func addToAssessments(_ value: Assessment)

    @objc(removeAssessmentsObject:)
    @NSManaged public func removeFromAssessments(_ value: Assessment)

    @objc(addAssessments:)
    @NSManaged public func addToAssessments(_ values: NSSet)

    @objc(removeAssessments:)
    @NSManaged public func removeFromAssessments(_ values: NSSet)

}

// MARK: Generated accessors for standards
extension UserSession {

    @objc(addStandardsObject:)
    @NSManaged public func addToStandards(_ value: Standard)

    @objc(removeStandardsObject:)
    @NSManaged public func removeFromStandards(_ value: Standard)

    @objc(addStandards:)
    @NSManaged public func addToStandards(_ values: NSSet)

    @objc(removeStandards:)
    @NSManaged public func removeFromStandards(_ values: NSSet)

}
