//
//  ElderSectionViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

class ElderSectionViewModel: ObservableObject {
    
    let assessment: Assessment
    var elders: [Elder] {
        return assessment.getElders()
    }
    
    init(assessment: Assessment) {
        self.assessment = assessment
    }
    
    func onAppear() {
        
        print("objectWillChange in eldersection")
        objectWillChange.send()
    }
    func delete(at offsets: IndexSet) {
        
        print("objectWillChange in delete elder")
        objectWillChange.send()
        for index in offsets {
            elders[index].delete()
        }
    }
    
}

