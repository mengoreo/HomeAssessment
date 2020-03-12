//
//  QuestionClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData

@objc(Question)
public class Question: NSManagedObject, Identifiable, NSSecureCoding {
    required convenience public init?(coder: NSCoder) {
        print("** decoding questions")
        self.init(context: CoreDataHelper.stack.context)
        dateCreated = coder.decodeObject(forKey: CodingKeys.dateCreated.rawValue) as! Date
        dateUpdated = coder.decodeObject(forKey: CodingKeys.dateUpdated.rawValue) as! Date
        index = coder.decodeInt32(forKey: CodingKeys.index.rawValue)
        measurable = coder.decodeBool(forKey: CodingKeys.measurable.rawValue)
        name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        uuid = coder.decodeObject(forKey: CodingKeys.uuid.rawValue) as! UUID
        options = coder.decodeObject(forKey: CodingKeys.options.rawValue) as? Set<Option>
//        // MARK: - Associate with standard, many to one REQUIRED!!
//        standard = coder.decodeObject(forKey: CodingKeys.standard.rawValue) as! Standard
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func create(for standard: Standard, index: Int32, name: String, measurable: Bool, uuidString: String) -> Question {
        let question = findById(with: UUID(uuidString: uuidString)!)
        if question != nil {
            if question!.measurable != measurable {
                for option in question!.getOptions() {
                    option.delete()
                }
            }
            question!.update(name: name, measurable: measurable)
            return question!
        }
        
        let newQuestion = Question(context: CoreDataHelper.stack.context)
        newQuestion.uuid = UUID(uuidString: uuidString)!
        newQuestion.dateCreated = Date()
        newQuestion.dateUpdated = Date()
        newQuestion.index = index
        newQuestion.name = name
        newQuestion.measurable = measurable
        newQuestion.standard = standard
        return newQuestion
    }
    
    class func all() -> [Question] {
        return CoreDataHelper.stack.fetch(fetch())
    }
    class func findById(with value: UUID) -> Question? {
        let request = fetch()
        let predicate = NSPredicate(format: "uuid == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    class func clear() {
        for ques in all() {
            ques.delete()
        }
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self.dateUpdated)
    }
    
    func update(_ force: Bool = false, name: String? = nil, measurable: Bool? = nil) {
        var updated = force
        if let name = name, name != self.name {
            self.name = name
            updated = true
        }
        if let measurable = measurable, measurable != self.measurable {
            self.measurable = measurable
            updated = true
        }
        if updated {
            self.dateUpdated = Date()
        }
    }
    func delete() {
        print(self, "deleting")
        CoreDataHelper.stack.context.delete(self)
    }
    func getOptions() -> [Option] {
//        Option.all().filter{$0.question == self}
        let request = Option.fetch()
        request.predicate = NSPredicate(format: "SELF IN %@", self.options!)
        return CoreDataHelper.stack.fetch(request)
    }
}
