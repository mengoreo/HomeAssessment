//
//  AppStatusClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData

@objc(AppStatus)
public class AppStatus: NSManagedObject {
    
    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func update(authorised: Bool? = nil,
                      lastOpenedTab: Int16? = nil,
                      lastUserName: String? = nil,
                      hideTabBar: Bool? = nil) {
        if let au = authorised { currentStatus.authorised = au}
        if let lt = lastOpenedTab { currentStatus.lastOpenedTab = lt }
        if let lu = lastUserName { currentStatus.lastUserName = lu }
        if let ht = hideTabBar {
            print("setting hide", ht)
            currentStatus.hideTabBar = ht }
//        if currentStatus.hasChanges { print("will save")
//            CoreDataHelper.stack.save() }
    }
    
    class func all() -> [AppStatus] {
        return CoreDataHelper.stack.fetch(self.fetch())
    }
    
    static var currentStatus: AppStatus {
//        for s in all() {
//            CoreDataHelper.stack.context.delete(s)
//        }
        if all().isEmpty {
            return create()
        }
        return all()[0]
    }
    
    static var errorMessage: ErrorMessage? = nil
    
    class func authorised() -> Bool {
        return currentStatus.authorised
    }
    class func create() -> AppStatus {
        let newStatus = AppStatus(context: CoreDataHelper.stack.context)
        newStatus.authorised = false
        newStatus.lastOpenedTab = 0 // first tab
        newStatus.lastUserName = ""
        newStatus.hideTabBar = false
        CoreDataHelper.stack.save()
        return newStatus
    }
}
