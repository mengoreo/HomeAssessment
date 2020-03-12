//
//  AppStatus+CoreDataClass.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData
import UIKit

@objc(AppStatus)
public class AppStatus: NSManagedObject, Identifiable, NSSecureCoding {
    required convenience public init?(coder: NSCoder) {
        print("** decoding AppStatus")
        self.init(context: CoreDataHelper.stack.context)
        authorised = coder.decodeObject(forKey: CodingKeys.authorised.rawValue) as! Bool
        hideTabBar = coder.decodeObject(forKey: CodingKeys.hideTabBar.rawValue) as! Bool
        lastOpenedTab = coder.decodeInt32(forKey: CodingKeys.lastOpenedTab.rawValue)
        lastUserName = coder.decodeObject(forKey: CodingKeys.lastUserName.rawValue) as! String
        lastUserInterface = coder.decodeInt32(forKey: CodingKeys.lastUserInterface.rawValue)
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }

    static var resultController = NSFetchedResultsController(fetchRequest: fetch(), managedObjectContext: CoreDataHelper.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    class func update(authorised: Bool? = nil,
                      lastOpenedTab: Int32? = nil,
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
        newStatus.lastUserInterface = Int32(UIScreen.main.traitCollection.userInterfaceStyle.rawValue)
//        CoreDataHelper.stack.save()
        return newStatus
    }
}
