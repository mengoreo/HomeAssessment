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
            assessment.managedObjectContext?.delete(contacts[index])
        }
    }
}
