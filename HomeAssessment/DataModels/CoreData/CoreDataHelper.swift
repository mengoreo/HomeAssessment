//
//  CoreData.swift
//  SwiftUI Core Data Test
//
//  Created by Chuck Hartman on 6/25/19.
//  Copyright © 2019 ForeTheGreen. All rights reserved.
//

import CoreData

class CoreDataHelper: NSObject {
    
    static let stack = CoreDataHelper()   // Singleton
    
    // MARK: - Core Data stack
    let modelName = "CoreDataModel"
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let nserror = error as NSError? {
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            } else {
                let description = NSPersistentStoreDescription()
                description.shouldMigrateStoreAutomatically = true
                description.shouldInferMappingModelAutomatically = true
                container.persistentStoreDescriptions = [description]
            }
        })
        return container
    }()
    
//
    
    var context: NSManagedObjectContext {
        
        get {
            let ct = persistentContainer.viewContext
            ct.undoManager = UndoManager()
            return ct
        }
        
    }
    
    // MARK: - Core Data support
    public func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            let objects = try self.context.fetch(request)
            return objects
        } catch {
            let nserror = error as NSError
            print("Unresolved fetch error \(nserror), \(nserror.userInfo)")
            return []
        }
    }
    
    public func clear(_ request: NSFetchRequest<NSFetchRequestResult>) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try self.context.execute(deleteRequest)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved clear error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    public func save() {
        
        if self.context.hasChanges {
            do {
                try self.context.save()
                print("In CoreData.stack.save()")
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved save error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Managed Object Helpers
    
    class func executeBlockAndCommit(_ block: @escaping () -> Void) {
        
        block()
        CoreDataHelper.stack.save()
    }
    
}
