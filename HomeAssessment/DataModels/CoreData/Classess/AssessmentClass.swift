//
//  AssessmentClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData
import CoreLocation

@objc(Assessment)
public class Assessment: NSManagedObject, Identifiable {
    
    public override var managedObjectContext: NSManagedObjectContext? {
        let contx = CoreDataHelper.stack.context
        contx.undoManager?.levelsOfUndo = 10
        
        return contx
    }
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func create(for user: UserSession, with standard: Standard?, remarks: String, address: CLPlacemark?) -> Assessment {

        let newAssessment = Assessment(context: CoreDataHelper.stack.context)
        newAssessment.uuid = UUID()
        newAssessment.dateCreated = Date()
        newAssessment.dateUpdated = Date()
        newAssessment.progress = 0
        newAssessment.remarks = remarks
        newAssessment.address = address
        newAssessment.standard = standard
        newAssessment.user = user
        newAssessment.user.update(true)
        
        return newAssessment
    }
    
    class func all() -> [Assessment] {
        return CoreDataHelper.stack.fetch(self.fetch())
    }
    
    class func clear() {
        for a in all() {
            a.delete()
        }
    }
    class func alreadyHas(_ remarks: String) -> Bool {
        return findByRemarks(with: remarks) != nil
    }
    class func findByRemarks(with value: String) -> Assessment? {
        
        let request = fetch()
        let predicate = NSPredicate(format: "remarks == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self.dateUpdated)
    }
    
    func update(_ force: Bool = false,
                remarks: String? = nil,
                progress: Double? = nil,
                address: CLPlacemark? = nil,
                standard: Standard? = nil) {
        var updated = force
        if let remarks = remarks, remarks != self.remarks {
            self.remarks = remarks
            updated = true
        }
        if let progress = progress, progress != self.progress {
            self.progress = progress
            updated = true
        }
        if let address = address, address != self.address {
            self.address = address
            updated = true
        }
        if let standard = standard, standard != self.standard {
            self.standard = standard
            updated = true
        }
        if updated {
            self.dateUpdated = Date()
        }
        print("** updated assessment")
        self.user.update(updated)
    }
    func delete() {
        print(self, "deleting")
        CoreDataHelper.stack.context.delete(self)
    }
    func getElders() -> [Elder] {
        return Elder.all().filter{$0.assessment == self}
    }
    func getContacts() -> [Contact] {
        return Contact.all().filter{$0.assessment == self}
    }
    func isValid() -> Bool {
        return
            !self.remarks.isEmpty
                &&
                !self.getElders().isEmpty
                &&
                !self.getContacts().isEmpty
                &&
                self.standard != nil
    }
}
