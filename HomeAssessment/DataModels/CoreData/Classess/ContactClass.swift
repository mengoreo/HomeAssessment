//
//  ContactClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData

@objc(Contact)
public class Contact: NSManagedObject, Identifiable {
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    class func create(for assessment: Assessment, name: String, phone: String) -> Contact{
        let newContact = Contact(context: CoreDataHelper.stack.context)
        newContact.uuid = UUID()
        newContact.dateCreated = Date()
        newContact.dateUpdated = Date()
        newContact.name = name
        newContact.phone = phone
        newContact.assessment = assessment
        newContact.assessment.update(true)
        
        return newContact
    }
    
    class func all() -> [Contact] {
        return CoreDataHelper.stack.fetch(fetch())
    }
    class func alreadyHas(_ name: String) -> Bool {
        return findByName(with: name) != nil
    }
    class func findByName(with value: String) -> Contact? {
        
        let request = fetch()
        let predicate = NSPredicate(format: "name == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    
    class func clear() {
        for c in all() {
            c.delete()
        }
    }
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self.dateUpdated)
    }
    
    func update(_ force: Bool = false, name: String? = nil, phone: String? = nil) {
        var updated = force
        if let name = name, name != self.name {
            self.name = name
            updated = true
        }
        if let phone = phone, phone != self.phone {
            self.phone = phone
            updated = true
        }
        if updated {self.dateUpdated = Date()}
        self.assessment.update(updated)
//        CoreDataHelper.stack.save()
    }
    func delete() {
        print(self, "deleting")
        CoreDataHelper.stack.context.delete(self)
    }
    func isValid() -> Bool {
        print("checking name: \(self.name); phone: \(self.phone)")
        return
            !self.name.isEmpty
            &&
            !self.phone.isEmpty

    }
    
}
