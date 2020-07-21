//
//  NewEditContactViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData

class NewEditContactViewModel: ObservableObject {
    @Published var contactName: String
    @Published var contactPhone: String
    
    private var assessment: Assessment
    var contact: Contact?
    init(assessment: Assessment, contact: Contact? = nil) {
        self.assessment = assessment
        self.contact = contact
        contactName = contact?.name ?? "fake"
        contactPhone = contact?.phone ?? "177"
    }
    
    var doneButtonDisabled: Bool {
        return contactName.isEmpty || contactPhone.isEmpty
    }
    lazy var barTitle: String = {
        return contactName.isEmpty ? "新建联系人" : contactName
    }()
    
    func save() {
        if let contact = contact {
            contact.update(name: contactName, phone: contactPhone)
        }else {
            print("add to contacts")
            contact = Contact.create(name: contactName, phone: contactPhone)
        }
        
//        contact?.setPrimitiveValue(assessment, forKey: "assessment")
        contact?.assessment = assessment
        
    }
}
