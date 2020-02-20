//
//  AssessmentListViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/18.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import SwiftUI

class AssessmentListViewModel: ObservableObject {
    @Published var searchTerm : String = ""
    @Published var currentSection = 0
    var section = ["概览", "报告"]
    @Published var adding = false
    
    @Published var displayActionSheet = false
    
    @Published var uiProperties = ALUIProperties(imgWidth: Device.width / 7,
                                                 imgXOffset: Device.width / 8,
                                                 imgYOffset: Device.width / 8)
    
    
    func readyForDisplay() {
        DispatchQueue.main.async {
            self.uiProperties.imgWidth = 20
            self.uiProperties.imgXOffset = -13
            self.uiProperties.imgYOffset = 0
        }
        
    }
}
