//
//  UserSessionClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData

@objc(UserSession)
public class UserSession: NSManagedObject, Identifiable, NSSecureCoding {
    required convenience public init?(coder: NSCoder) {
        print("** decoding UserSession")
        self.init(context: CoreDataHelper.stack.context)
        dateCreated = coder.decodeObject(forKey: CodingKeys.dateCreated.rawValue) as! Date
        dateUpdated = coder.decodeObject(forKey: CodingKeys.dateUpdated.rawValue) as! Date
        name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        token = coder.decodeObject(forKey: CodingKeys.token.rawValue) as! String
        uuid = coder.decodeObject(forKey: CodingKeys.uuid.rawValue) as! UUID
//        assessments = coder.decodeObject(forKey: CodingKeys.assessments.rawValue) as? Set<Assessment>
//        standards = coder.decodeObject(forKey: CodingKeys.standards.rawValue) as? Set<Standard>
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    class func create(name: String, token: String) -> UserSession {
        let newUser = UserSession(context: CoreDataHelper.stack.context)
        newUser.uuid = UUID()
        newUser.dateCreated = Date()
        newUser.dateUpdated = Date()
        newUser.name = name
        newUser.token = token
        return newUser
    }
    
    class func performCreate(name: String,
                      password: String,
                      completionHandler: @escaping (_ errorMessage: ErrorMessage?) -> Void) {
        // for test
        if name == "Mengoreo" {
            _ = create(name: "Mengoreo", token: "fake")
            AppStatus.update(authorised: true, lastUserName: "Mengoreo")
            completionHandler(nil)
            return
        }
        
        guard !name.isEmpty else {
            completionHandler(ErrorMessage(body: "用户名不能为空", type: .signInError(.nameField)))
            return
        }
        guard !password.isEmpty else {
            completionHandler(ErrorMessage(body: "密码不能为空", type: .signInError(.passwordField)))
            return
        }
        
        let tokenFetcher = TokenFetcher(name: name, password: password)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tokenFetcher.fetchToken { (token, error) in
            print("** token", token)
            guard error == nil else {
                AppStatus.errorMessage = ErrorMessage(body: error!.cnDescription(), type: .serverError)
                completionHandler(ErrorMessage(body: error!.cnDescription(), type: .signInError(.passwordField)))
                return
            }
            if let user = findByName(with: name) {
                user.update(token: token)
            } else {
                _ = create(name: name, token: token)
            }
            AppStatus.update(authorised: true, lastUserName: name)
            completionHandler(nil)
        }
        }
    }
    class func initialSetup() {
        if all().count == 0{
//            _ = create(name: "m", token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYTZhOTc2NTctYzQ5Mi00MTBiLWE2YzYtOThiMTY2ZjBhMDdmIiwidXNlcm5hbWUiOiJtIiwiZXhwIjoxNjY4NjAwNjM5LCJlbWFpbCI6IiJ9.mHuy3atAjX_5B0YoQ4sS3F1GY3M4WdCsk7QAvRWLuLU", uuidString: "a6a97657-c492-410b-a6c6-98b166f0a07f")
        }
    }
    
    public static var currentUser: UserSession {
        // only called after appstatus updated valid username
        return findByName(with: AppStatus.currentStatus.lastUserName)!
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
    class func findByName(with value: String) -> UserSession? {
        let request = fetch()
        let predicate = NSPredicate(format: "name == %@", value as CVarArg)
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
    
    func isValid() -> Bool {
        return false
    }
}
