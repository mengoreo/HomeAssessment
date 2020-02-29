//
//  AssessmentClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData
import CoreLocation
import UIKit

@objc(Assessment)
public class Assessment: NSManagedObject, Identifiable {
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func create(for user: UserSession, with standard: Standard?, remarks: String, address: CLPlacemark?) -> Assessment {

        let newAssessment = Assessment(context: CoreDataHelper.stack.context)
        newAssessment.uuid = UUID()
        newAssessment.dateCreated = Date()
        newAssessment.dateUpdated = Date()
        newAssessment.progress = 0
        newAssessment.remarks = remarks
        newAssessment.address = address
        newAssessment.mapPreviewNeedsUpdate = address != nil
        newAssessment.standard = standard
        newAssessment.user = user
        
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
        dateFormatter.dateFormat = "yyyy"
        if dateFormatter.string(from: Date()) != dateFormatter.string(from: self.dateUpdated) {
            dateFormatter.dateFormat = "HH:mm yyyy-MM-dd"
        } else {
            dateFormatter.dateFormat = "HH:mm MM-dd"
        }
        return dateFormatter.string(from: dateUpdated)
    }
    
    func update(_ force: Bool = false,
                remarks: String? = nil,                
                address: CLPlacemark? = nil,
                preview: UIImage? = nil,
                progress: Double? = nil,
                standard: Standard? = nil) {
        var updated = force
        if let remarks = remarks, remarks != self.remarks {
            print("** update remarks")
            self.remarks = remarks
            updated = true
        }
        if let progress = progress, progress != self.progress {
            print("** update progress")
            self.progress = progress
            updated = true
        }
        if let address = address {
            if self.address == nil || !self.address!.isEqualTo(address){
                print("** update address")
                self.address = address
                self.mapPreviewNeedsUpdate = true
                updated = true
            }
        }
        if let image = preview, image != self.mapPreview {
            self.mapPreview = image
            self.mapPreviewNeedsUpdate = false
            updated = true
        }
        if let standard = standard, standard != self.standard {
            print("** update standard")
            self.standard = standard
            updated = true
        }
        if updated {
            print("** update date")
            self.dateUpdated = Date()
        }
        print("** updated assessment")
    }
    
    func delete() {
        print(self, "deleting")
        CoreDataHelper.stack.context.delete(self)
        CoreDataHelper.stack.save()
    }
    func getElders() -> [Elder] {
        if self.elders != nil {
            let request = Elder.fetch()
            request.predicate = NSPredicate(format: "SELF IN %@", self.elders!)
            return CoreDataHelper.stack.fetch(request)
        }
        return []
//        return Elder.all().filter{$0.assessment == self}
    }
    func getContacts() -> [Contact] {
        if self.contacts != nil {
            let request = Contact.fetch()
            request.predicate = NSPredicate(format: "SELF IN %@", self.contacts!)
            return CoreDataHelper.stack.fetch(request)
        }
        return []
//        return Contact.all().filter{$0.assessment == self}
    }
    func isValid() -> Bool {
        return
            !self.remarks.isEmpty
                &&
                !self.getElders().isEmpty
                &&
                !self.getContacts().isEmpty
                &&
                self.address != nil
    }
}
