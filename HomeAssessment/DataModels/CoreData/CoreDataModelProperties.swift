//
//  CoreDataModelProperties.swift
//  tet
//
//  Created by Mengoreo on 2020/2/23.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData
import MapKit

// MARK: - UserSession
extension UserSession {

    @nonobjc public class func fetch() -> NSFetchRequest<UserSession> {
        let request = NSFetchRequest<UserSession>(entityName: "UserSession")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var name: String
    @NSManaged public var token: String
    @NSManaged public var standards: Standard? // to many - cascade
    @NSManaged public var assessments: Assessment? // to many - cascade
    
}

// MARK: - Assessment
extension Assessment {

    @nonobjc public class func fetch() -> NSFetchRequest<Assessment> {
        let request = NSFetchRequest<Assessment>(entityName: "Assessment")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @NSManaged public var uuid: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var progress: Double
    @NSManaged public var remarks: String
    @NSManaged public var address: CLPlacemark?
    @NSManaged public var user: UserSession // to one - nullify
    @NSManaged public var standard: Standard? // to one - nullify
    @NSManaged public var contacts: Contact? // to many - cascade
    @NSManaged public var elders: Elder? // to many - cascade
    
}

// MARK: - Elder
extension Elder {
    @nonobjc public class func fetch() -> NSFetchRequest<Elder> {
        let request = NSFetchRequest<Elder>(entityName: "Elder")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @NSManaged public var uuid: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var name: String
    @NSManaged public var heightInCM: Int32
    @NSManaged public var status: String
    @NSManaged public var assessment: Assessment

}

// MARK: - Contact
extension Contact {

    @nonobjc public class func fetch() -> NSFetchRequest<Contact> {
        let request = NSFetchRequest<Contact>(entityName: "Contact")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var assessment: Assessment // to one

}

// MARK: - Standard

extension Standard {

    @nonobjc public class func fetch() -> NSFetchRequest<Standard> {
        let request = NSFetchRequest<Standard>(entityName: "Standard")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var name: String
    @NSManaged public var index: Int32
    @NSManaged public var user: UserSession // to one
    @NSManaged public var assessments: Assessment? // to many - nullify
    @NSManaged public var questions: Question? // to many - cascade

}

// MARK: - Question

extension Question {

    @nonobjc public class func fetch() -> NSFetchRequest<Question> {
        let request = NSFetchRequest<Question>(entityName: "Question")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @NSManaged public var uuid: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var name: String
    @NSManaged public var index: Int32
    @NSManaged public var measurable: Bool
    
    @NSManaged public var standard: Standard // to one
    @NSManaged public var options: Option? // to many - cascade
    
}

// MARK: - Option

extension Option {

    @nonobjc public class func fetch() -> NSFetchRequest<Option> {
        let request = NSFetchRequest<Option>(entityName: "Option")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @NSManaged public var uuid: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var optionDescription: String
    @NSManaged public var from_val: Double
    @NSManaged public var to_val: Double
    @NSManaged public var vote: Double
    @NSManaged public var index: Int32
    @NSManaged public var suggestion: String
    
    @NSManaged public var question: Question

}

