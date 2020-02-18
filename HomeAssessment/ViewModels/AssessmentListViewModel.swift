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
    
    @Published var imgWidth: CGFloat = Device.width / 7
    @Published var imgXOffset: CGFloat = Device.width / 8
    @Published var imgYOffset: CGFloat = Device.width / 8
    
    func readyForDisplay() {
        imgWidth = 20
        imgXOffset = -10
        imgYOffset = 0
    }
}
