//
//  Standard+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import Foundation
import CoreData


extension Standard {

    @nonobjc public class func fetch() -> NSFetchRequest<Standard> {
        let request = NSFetchRequest<Standard>(entityName: "Standard")
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date
    @NSManaged public var index: Int32
    @NSManaged public var name: String
    @NSManaged public var uuid: UUID
    @NSManaged public var assessments: Set<Assessment>?
    @NSManaged public var questions: Set<Question>?
    @NSManaged public var user: UserSession

    enum CodingKeys:String, CodingKey {
        case dateCreated,
        dateUpdated,
        index,
        name,
        uuid,
        assessments,
        questions,
        user
        
    }
}

// MARK: - NSSecureCoding
extension Standard {
    public func encode(with encoder: NSCoder) {
        print("** ecoding Standard")
        encoder.encode(dateCreated, forKey: CodingKeys.dateCreated.rawValue)
        encoder.encode(dateUpdated, forKey: CodingKeys.dateUpdated.rawValue)
        encoder.encode(index, forKey: CodingKeys.index.rawValue)
        encoder.encode(name, forKey: CodingKeys.name.rawValue)
        encoder.encode(uuid, forKey: CodingKeys.uuid.rawValue)
        encoder.encode(assessments, forKey: CodingKeys.assessments.rawValue)
        encoder.encode(questions, forKey: CodingKeys.questions.rawValue)
        encoder.encode(user, forKey: CodingKeys.user.rawValue)
    }
}
// MARK: Generated accessors for assessments
extension Standard {

    @objc(addAssessmentsObject:)
    @NSManaged public func addToAssessments(_ value: Assessment)

    @objc(removeAssessmentsObject:)
    @NSManaged public func removeFromAssessments(_ value: Assessment)

    @objc(addAssessments:)
    @NSManaged public func addToAssessments(_ values: NSSet)

    @objc(removeAssessments:)
    @NSManaged public func removeFromAssessments(_ values: NSSet)

}

// MARK: Generated accessors for questions
extension Standard {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: Question)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: Question)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}
