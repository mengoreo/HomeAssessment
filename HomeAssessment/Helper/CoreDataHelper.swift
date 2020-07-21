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
//    let modelName = "CoreDataModel"
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

                container.viewContext.automaticallyMergesChangesFromParent = true
                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                container.viewContext.undoManager = nil
//                container.viewContext.shouldDeleteInaccessibleFaults = true
            }
        })
        return container
    }()
    
//
    let coreDataQueue = DispatchQueue(label: "coreDataQueue")
    var context: NSManagedObjectContext {
        
        get {
            let ct = persistentContainer.viewContext
            ct.undoManager = UndoManager()
            return ct
        }
        
    }
    
//    private var saveQueue = Dispaque
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
        print("In CoreData.stack.save() about to save \(DispatchTime.now().rawValue)")
        
        Run.async(coreDataQueue) {
            // MARK: saving in same queue prevent Cryptic error from Core Data: NSInvalidArgumentException, reason: referenceData64 only defined for abstract class
            self.context.performAndWait { // incase multithread saving
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
        }

//        completionHandler()
        print("In CoreData.stack.save() saved \(DispatchTime.now().rawValue)")
    }
    
    public func delete(_ managedObject: NSManagedObject) {
        Run.async(coreDataQueue) {
            self.context.performAndWait {
//                let fooObject = self.context.object(with: managedObject.objectID)
                self.context.delete(managedObject)
                /// you can only delete an object from its context and a context is thread bound. The issue here is not how long the save takes but where you are saving.

               /// You should avoid expensive operations in any UI facing method call like this one. There is no reason to save immediately after a delete. Save later, save when the user is expecting a delay in the UI. Core Data will work just fine without the save.
//                do {
//                    try self.context.save()
//                    print("In CoreData.stack.save()")
//                } catch {
//
//                    let nserror = error as NSError
//                    fatalError("Unresolved save error \(nserror), \(nserror.userInfo)")
//                }
            }
            print("** deleted and saved")
        }
    }
    
    public func rollback() {
        Run.async(coreDataQueue) {
            self.context.performAndWait {
                self.context.rollback()
            }
        }
    }
    public func saveForSceneDelegate() {
        print("saving ForSceneDelegate")
        if context.hasChanges {
            do {
                try context.save()
                print("In CoreData.stack.saveForSceneDelegate()")
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
