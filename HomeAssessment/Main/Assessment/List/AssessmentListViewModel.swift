//
//  AssessmentListViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/18.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData
import SwiftUI
import MapKit

class AssessmentListViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    var assessments: [Assessment]
    {
        return UserSession.currentUser.assessments?.sorted(by: {($0.dateUpdated ?? Date()).timeIntervalSince1970 > ($1.dateUpdated ?? Date()).timeIntervalSince1970})
            .filter{$0.isValid()}
            ?? []

    }
    @Published var showNewAssessmentModal = false
    @Published var updating = false
    var editingAssessment = false
    
    override init() {
        super.init()
        // MARK: - 当编辑时，停止代理的更新
        NotificationCenter.default.addObserver(self, selector: #selector(pauseUpdate), name: .WillEditAssessment, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willShare(_:)), name: .WillShareAssessment, object: nil)
    }
    func onAppear() {
        objectWillChange.send() // perform fetch in welcom view
        Assessment.resultController.delegate = self
        // MARK: - Update after delete
        try? Assessment.resultController.performFetch()
        AppStatus.update(lastOpenedTab: 0, hideTabBar: false)
        
        for ass in assessments {
            print(ass.dateCreated.distance(to: Date()))
        }
    }
    @objc func pauseUpdate() {
        // MARK: - 借此停止接收更新通知
        Assessment.resultController.delegate = nil
    }
    
    @objc func willShare(_ noti: Notification) {
        print(noti)
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // MARK: - 刷新视图
        objectWillChange.send()
    }
    
    
    func fakeCreate() {
        let a = Assessment.create(for: .currentUser, with: UserSession.currentUser.standards?.first ?? nil, remarks: "fake", address: nil)
        _ = Contact.create(for: a, name: "fake", phone: "177")
        Elder.create(for: a, name: "fake", heightInCM: 100, status: "fake")
        a.address = MKPlacemark(coordinate: .init(latitude: 17.978733, longitude: -0.791016))
    }
    
    func aboutCreateNewAssessment() {
        showNewAssessmentModal = true
    }
    func newAssessmentModalDismissed() {
        AppStatus.update(hideTabBar: false)
    }
    
    
}
