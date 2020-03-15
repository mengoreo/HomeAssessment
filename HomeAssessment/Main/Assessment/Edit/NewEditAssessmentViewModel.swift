//
//  NewEditAssessmentViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData
import MapKit

class NewEditAssessmentViewModel: ObservableObject {
    
    @Published var searchStandardModal: Bool = false
    @Published var selectedStandardIndex = 0
    @Published var remarks: String!
    @Published var presentingMap = false
    @Published var locatedAt: MKPlacemark?
    @Published var editingRemarks = false
    @Published var saving = false
    
    var contact: Contact? = nil
//    var id: UUID
    
    var assessment: Assessment
    init(assessment: Assessment) {
        print("initing NewEditAssessmentView")
        self.assessment = assessment
//        super.init()
        // MARK: - important?
        remarks = assessment.remarks
        selectedStandardIndex = Int(assessment.standard?.index ?? 0)
        locatedAt = assessment.address == nil ? nil : MKPlacemark(placemark: assessment.address!)
    }
    
    
    var barTitle: String {
        saving
            ? "正在保存..."
            : (assessment.remarks.isEmpty
                ? "新建评估"
                : assessment.remarks)
    }
    
    var doneButtonDisabled: Bool {
        print("** done button", assessment)
        return assessment.getContacts().isEmpty // xie!!!!!!
            || assessment.getElders().isEmpty
            || locatedAt == nil
            || editingRemarks
    }
    
    var standards: [Standard] {
        assessment.user.standards?.sorted(by: {$0.index > $1.index}) ?? []
    }
    func didBeginEditingRemarks() {
        self.editingRemarks = true
    }
    func didEndEditingRemarks() {
        self.editingRemarks = false
    }
    func didSelect(_ place: MKAnnotation) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)) {placemarks, error in
            guard error == nil else {
                print("** userLocation reverse geo error: \(error!)")
                return
            }
            // Most geocoding requests contain only one result.
            if let firstPlacemark = placemarks?.first {
                self.locatedAt = MKPlacemark(placemark: firstPlacemark)
            }
        }
    }
    
    
    func cancel() {
        
    }
    func save(completionHandler: @escaping ()-> Void = {}) {
        print("** saving")
        if remarks.isEmpty {
            print("empty remakr")
            remarks = locatedAt?.name ?? "无备注"
        }
        assessment.update(remarks: remarks, address: locatedAt, progress: assessment.progress, standard: standards[selectedStandardIndex])
        
        saving = true
        CoreDataHelper.stack.save()
        print("** saved")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completionHandler()
        }
        
    }
    
}
