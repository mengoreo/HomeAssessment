//
//  ContactSectionViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

class ContactSectionViewModel: ObservableObject {
    
    let assessment: Assessment
    var contacts: [Contact] {
        assessment.getContacts()
//        Contact.all().filter{$0.assessment == assessment}
        
    }
    
    init(assessment: Assessment) {
        self.assessment = assessment
    }
    
    
    func onAppear() {
        print("contact section appear")
        objectWillChange.send()
    }
    
    func delete(at offsets: IndexSet) {
        objectWillChange.send()
        for index in offsets {
            print("index")
//            contacts[index].setPrimitiveValue(nil, forKey: "assessment")
            contacts[index].delete()
        }
    }
}
