//
//  StandardClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData

@objc(Standard)
public class Standard: NSManagedObject, Identifiable, NSSecureCoding {
    
    required convenience public init?(coder: NSCoder) {
        print("** decoding Standard")
        self.init(context: CoreDataHelper.stack.context)
        dateCreated = coder.decodeObject(forKey: CodingKeys.dateCreated.rawValue) as! Date
        dateUpdated = coder.decodeObject(forKey: CodingKeys.dateUpdated.rawValue) as! Date
        index = coder.decodeInt32(forKey: CodingKeys.index.rawValue)
        name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        uuid = coder.decodeObject(forKey: CodingKeys.uuid.rawValue) as! UUID
//        assessments = coder.decodeObject(forKey: CodingKeys.assessments.rawValue) as? Set<Assessment>
        questions = coder.decodeObject(forKey: CodingKeys.questions.rawValue) as? Set<Question>
//        user = coder.decodeObject(forKey: CodingKeys.user.rawValue) as! UserSession
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func create(for user: UserSession, name: String, index: Int, uuidString: String) -> Standard {
        let standard = findById(with: UUID(uuidString: uuidString)!)
        if standard != nil {
            standard!.update(name: name)
            return standard!
        }
        
        let newStandard = Standard(context: CoreDataHelper.stack.context)
        newStandard.name = name
        newStandard.index = Int32(index)
        newStandard.uuid = UUID(uuidString: uuidString)!
        newStandard.dateCreated = Date()
        newStandard.dateUpdated = Date()
        newStandard.user = user
        return newStandard
    }
    
    class func all() -> [Standard] {
        return CoreDataHelper.stack.fetch(fetch())
    }
    class func findById(with value: UUID) -> Standard? {
        
        let request = fetch()
        let predicate = NSPredicate(format: "uuid == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    class func clear() {
        let standards = all()
        for standard in standards {
            standard.delete()
        }
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self.dateUpdated)
    }
    
    func update(_ force: Bool = false, name: String? = nil) {
        var updated = force
        if let name = name, name != self.name {
            self.name = name
            updated = true
        }
        if updated {self.dateUpdated = Date()}
    }
    func delete() {
        print(self, "deleting")
        CoreDataHelper.stack.context.delete(self)
    }
    func getQuestions() -> [Question] {
        let request = Question.fetch()
        request.predicate = NSPredicate(format: "SELF IN %@", self.questions!)
        return CoreDataHelper.stack.fetch(request)
    }
    
    func getAssessments() -> [Assessment] {
        print("*** geting Assessments")
        return Assessment.all().filter{$0.standard == self}
//        let request = Assessment.fetch()
//        request.predicate = NSPredicate(format: "SELF IN %@", self.assessments!)
//
//        return CoreDataHelper.stack.fetch(request)
    }
}
