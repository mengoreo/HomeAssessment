//
//  ElderClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData

@objc(Elder)
public class Elder: NSManagedObject, Identifiable, NSSecureCoding  {
    required convenience public init?(coder: NSCoder) {
        print("** decoding Elder")
        self.init(context: CoreDataHelper.stack.context)
        dateCreated = coder.decodeObject(forKey: CodingKeys.dateCreated.rawValue) as! Date
        dateUpdated = coder.decodeObject(forKey: CodingKeys.dateUpdated.rawValue) as! Date
        heightInCM = coder.decodeObject(forKey: CodingKeys.heightInCM.rawValue) as? Int32 ?? 0
        status = coder.decodeObject(forKey: CodingKeys.status.rawValue) as! String
        name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        uuid = coder.decodeObject(forKey: CodingKeys.uuid.rawValue) as! UUID
//        assessment = coder.decodeObject(forKey: CodingKeys.assessment.rawValue) as! Assessment
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    class func create(for assessment: Assessment, name: String, heightInCM: Int32, status: String) {
        let newElder = Elder(context: CoreDataHelper.stack.context)
        newElder.uuid = UUID()
        newElder.dateCreated = Date()
        newElder.dateUpdated = Date()
        newElder.name = name
        newElder.heightInCM = heightInCM
        newElder.status = status
        newElder.assessment = assessment
    }
    
    class func create(name: String, heightInCM: Int32, status: String) -> Elder {
        let newElder = Elder(context: CoreDataHelper.stack.context)
        newElder.uuid = UUID()
        newElder.dateCreated = Date()
        newElder.dateUpdated = Date()
        newElder.name = name
        newElder.heightInCM = heightInCM
        newElder.status = status
        return newElder
    }
    
    class func all() -> [Elder] {
        return CoreDataHelper.stack.fetch(fetch())
    }
    class func alreadyHas(_ name: String) -> Bool {
        return findByName(with: name) != nil
    }
    class func findByName(with value: String) -> Elder? {
        
        let request = fetch()
        let predicate = NSPredicate(format: "name == %@", value as CVarArg)
        request.predicate = predicate
        
        let result = CoreDataHelper.stack.fetch(request)
        return result.first
    }
    class func clear() {
        for e in all() {
            e.delete()
        }
    }
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self.dateUpdated)
    }
    
    func update(_ forced: Bool = false,
                name: String? = nil,
                heightInCM: Int32? = nil,
                status: String? = nil) {
        var updated = forced
        if let n = name, n != self.name {
            self.name = n
            updated = true
        }
        if let h = heightInCM, h != self.heightInCM {
            self.heightInCM = h
            updated = true
        }
        if let s = status, s != self.status {
            self.status = s
            updated = true
        }
        if updated {self.dateUpdated = Date()}
    }
    func delete() {
        print(self, "deleting")
//        setPrimitiveValue(nil, forKey: "assessment")
        CoreDataHelper.stack.context.delete(self)
    }
    

}
