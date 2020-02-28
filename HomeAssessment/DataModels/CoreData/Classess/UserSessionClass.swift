//
//  UserSessionClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData

@objc(UserSession)
public class UserSession: NSManagedObject, Identifiable {
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    class func create(name: String, token: String, uuidString: String) -> UserSession {
        let newUser = UserSession(context: CoreDataHelper.stack.context)
        newUser.uuid = UUID(uuidString: uuidString)!
        newUser.dateCreated = Date()
        newUser.dateUpdated = Date()
        newUser.name = name
        newUser.token = token
        return newUser
    }
    class func initialSetup() {
        if all().count == 0{
            _ = create(name: "m", token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYTZhOTc2NTctYzQ5Mi00MTBiLWE2YzYtOThiMTY2ZjBhMDdmIiwidXNlcm5hbWUiOiJtIiwiZXhwIjoxNjY4NjAwNjM5LCJlbWFpbCI6IiJ9.mHuy3atAjX_5B0YoQ4sS3F1GY3M4WdCsk7QAvRWLuLU", uuidString: "a6a97657-c492-410b-a6c6-98b166f0a07f")
        }
    }
    
    public static var currentUser: UserSession {
        initialSetup()
        return all()[0]
    }
    class func all() -> [UserSession] {
        return CoreDataHelper.stack.fetch(self.fetch())
    }
    class func clear() {
        for user in all() {
            user.delete()
        }
    }
    class func findById(with value: UUID) -> UserSession? {
        
        let request = fetch()
        let predicate = NSPredicate(format: "uuid == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self.dateUpdated)
    }
    
    func update(_ force: Bool = false, name: String? = nil, token: String? = nil) {
        var updated = force
        if let name = name, name != self.name {
            self.name = name
            updated = true
        }
        if let token = token, token != self.token {
            self.token = token
            updated = true
        }
        if updated {
            self.dateUpdated = Date()
        }
        
        print("*** updated user")
    }
    func delete() {
        print(self, "deleting")
        CoreDataHelper.stack.context.delete(self)
    }
    func getAssessments() -> [Assessment] {
        return Assessment.all().filter{$0.user == self}
    }
    func getStandards() -> [Standard] {
        return Standard.all().filter{$0.user == self}
    }

}
