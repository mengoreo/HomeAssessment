//
//  OptionClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData

@objc(Option)
public class Option: NSManagedObject, Identifiable {
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func create(for question: Question, index: Int32, optionDescription: String, from_val: Double, to_val: Double, vote: Double, suggestion: String, uuidString: String) {
        
        let option = findById(with: UUID(uuidString: uuidString)!)
        if option != nil {
            option!.update(optionDescription: optionDescription, from_val: from_val, to_val: to_val, vote: vote, suggestion: suggestion)
            return
        }
        
        let newOption = Option(context: CoreDataHelper.stack.context)
        newOption.uuid = UUID(uuidString: uuidString)!
        newOption.dateCreated = Date()
        newOption.dateUpdated = Date()
        newOption.index = index
        newOption.optionDescription = optionDescription
        newOption.from_val = from_val
        newOption.to_val = to_val
        newOption.vote = vote
        newOption.suggestion = suggestion
        newOption.question = question
        
    }
    
    class func all() -> [Option] {
        return CoreDataHelper.stack.fetch(fetch())
    }
    class func findById(with value: UUID) -> Option? {
        let request = fetch()
        let predicate = NSPredicate(format: "uuid == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    class func clear() {
        for o in all() {
            o.delete()
        }
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self.dateUpdated)
    }
    
    func update(_ force: Bool = false,
                optionDescription: String? = nil,
                from_val: Double? = nil,
                to_val: Double? = nil,
                vote: Double? = nil,
                suggestion: String? = nil) {
        var updated = force
        if let des = optionDescription, des != self.optionDescription {
            self.optionDescription = des
            updated = true
        }
        if let from = from_val, from != self.from_val {
            self.from_val = from
            updated = true
        }
        if let to = to_val, to != self.to_val {
            self.to_val = to
            updated = true
        }
        if let vote = vote, vote != self.vote {
            self.vote = vote
            updated = true
        }
        if let suggestion = suggestion, suggestion != self.suggestion {
            self.suggestion = suggestion
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
    

}
