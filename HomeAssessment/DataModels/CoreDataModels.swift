//
//  CoreDataModels.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/19.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(User)
public class User: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        let request = NSFetchRequest<User>(entityName: "User")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var standards: [Standard]?
    @NSManaged public var token: String
    @NSManaged public var assessments: [Assessment]?

}

@objc(Assessment)
public class Assessment: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assessment> {
        return NSFetchRequest<Assessment>(entityName: "Assessment")
    }

    @NSManaged public var contact: Contact?
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var id: UUID
    @NSManaged public var userID: UUID
    @NSManaged public var progress: Float
    @NSManaged public var remarks: String
    @NSManaged public var standard: Standard?

}

@objc(Contact)
public class Contact: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var address: CLPlacemark?
    @NSManaged public var id: UUID
    @NSManaged public var assessmentID: UUID
    @NSManaged public var name: String
    @NSManaged public var phone: String

}

@objc(Standard)
public class Standard: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Standard> {
        return NSFetchRequest<Standard>(entityName: "Standard")
    }

    @NSManaged public var questions: [Question]?
    @NSManaged public var name: String
    @NSManaged public var id: UUID
    @NSManaged public var userID: UUID

}

@objc(Question)
public class Question: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var measurable: Bool
    @NSManaged public var options: [Option]?
    @NSManaged public var questionName: String
    @NSManaged public var id: UUID
    @NSManaged public var standardID: UUID

}

@objc(Option)
public class Option: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Option> {
        return NSFetchRequest<Option>(entityName: "Option")
    }

    @NSManaged public var optionDescription: String?
    @NSManaged public var from_val: Double
    @NSManaged public var to_val: Double
    @NSManaged public var vote: Double
    @NSManaged public var id: UUID
    @NSManaged public var questionID: UUID

}


