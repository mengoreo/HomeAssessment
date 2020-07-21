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

class NewEditAssessmentViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
//    @Published var searchStandardModal: Bool = false
    @Published var selectedStandardIndex = 0
    @Published var remarks: String!
    @Published var presentingMap = false
    @Published var locatedAt: MKPlacemark?
    @Published var editingRemarks = false
    @Published var saving = false
    
//    var contact: Contact? = nil
    let barTitle: String
    
    var assessment: Assessment!
    init(assessment: Assessment? = nil) {
        barTitle = assessment?.remarks ?? "新建评估"
        super.init()
        // MARK: - 通知即将编辑评估
        NotificationCenter.default.post(name: .WillEditAssessment, object: nil, userInfo: nil)
        Assessment.resultController.delegate = self
        // MARK: - 必要的初始化
        self.assessment = assessment ?? .create(for: .currentUser, with: nil, remarks: "", address: nil)
        remarks = self.assessment.remarks
        selectedStandardIndex = Int(self.assessment.standard?.index ?? 0)
        locatedAt = self.assessment.address == nil ? nil : MKPlacemark(placemark: self.assessment.address!)
    }
    var doneButtonDisabled: Bool {
        // MARK: - 必要信息非空之后，启用保存按钮
        return assessment.getContacts().isEmpty || assessment.getElders().isEmpty || locatedAt == nil || editingRemarks
    }
    func didSelect(_ place: MKAnnotation) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)) {placemarks, error in
            guard error == nil else {
                return
            }
            if let firstPlacemark = placemarks?.first {
                self.locatedAt = MKPlacemark(placemark: firstPlacemark)
            }
        }
    }
    func cancel() {
        // MARK: - 取消「订阅」
        Assessment.resultController.delegate = nil
        // MARK: - 撤销
        CoreDataHelper.stack.rollback()
    }
    func save(completionHandler: @escaping ()-> Void = {}) {
        saving = true
        Assessment.resultController.delegate = nil
        if remarks.isEmpty { remarks = locatedAt?.name ?? "无备注" }
        assessment.update(remarks: remarks, address: locatedAt, progress: assessment.progress, standard: standards.isEmpty ? nil : standards[selectedStandardIndex])
        // MARK: - 保存
        CoreDataHelper.stack.save()
        completionHandler()
    }
    
    var standards: [Standard] {
        UserSession.currentUser.standards?.sorted(by: {$0.index > $1.index}) ?? []
    }
    func onAppear() {
        
    }
    
    func didBeginEditingRemarks() {
        self.editingRemarks = true
    }
    func didEndEditingRemarks() {
        self.editingRemarks = false
    }
    
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
    
}
