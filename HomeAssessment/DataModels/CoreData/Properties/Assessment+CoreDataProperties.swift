//
//  Assessment+CoreDataProperties.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
//

import CoreData
import MapKit

extension Assessment {

    @nonobjc public class func fetch() -> NSFetchRequest<Assessment> {
        let request = NSFetchRequest<Assessment>(entityName: "Assessment")
        let sortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var address: CLPlacemark?
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateUpdated: Date?
    @NSManaged public var mapPreviewNeedsUpdate: Bool
    @NSManaged public var progress: Double
    @NSManaged public var remarks: String
    @NSManaged public var selectedOptions: [UUID: UUID] // question-option
    @NSManaged public var uuid: UUID
    @NSManaged public var contacts: Set<Contact>?
    @NSManaged public var elders: Set<Elder>?
    @NSManaged public var standard: Standard?
    @NSManaged public var user: UserSession // required
    @NSManaged public var capturedImages: ThumbnailImage?
    @NSManaged public var mapPreview: ThumbnailImage?

}

// MARK: Generated accessors for contacts
extension Assessment {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

// MARK: Generated accessors for elders
extension Assessment {

    @objc(addEldersObject:)
    @NSManaged public func addToElders(_ value: Elder)

    @objc(removeEldersObject:)
    @NSManaged public func removeFromElders(_ value: Elder)

    @objc(addElders:)
    @NSManaged public func addToElders(_ values: NSSet)

    @objc(removeElders:)
    @NSManaged public func removeFromElders(_ values: NSSet)

}

// MARK: Generated accessors for capturedImages
extension Assessment {

    @objc(addCapturedImagesObject:)
    @NSManaged public func addToCapturedImages(_ value: ThumbnailImage)

    @objc(removeCapturedImagesObject:)
    @NSManaged public func removeFromCapturedImages(_ value: ThumbnailImage)

    @objc(addCapturedImages:)
    @NSManaged public func addToCapturedImages(_ values: NSSet)

    @objc(removeCapturedImages:)
    @NSManaged public func removeFromCapturedImages(_ values: NSSet)

}
