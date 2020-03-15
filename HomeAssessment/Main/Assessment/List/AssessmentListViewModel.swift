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
    
    var assessmentToCreate: Assessment? = nil
    
    func onAppear() {
        print("asslist will appear")
        objectWillChange.send() // perform fetch in welcom view
        print("elders:", Elder.all())
        print("contact:", Contact.all())
        Assessment.resultController.delegate = self
        try? Assessment.resultController.performFetch()
        AppStatus.update(lastOpenedTab: 0, hideTabBar: false)
    }
    
    func fakeCreate() {
        let a = Assessment.create(for: .currentUser, with: Standard.all().first ?? nil, remarks: "fake", address: nil)
        _ = Contact.create(for: a, name: "fake", phone: "177")
        Elder.create(for: a, name: "fake", heightInCM: 100, status: "fake")
        a.address = MKPlacemark(coordinate: .init(latitude: 17.978733, longitude: -0.791016))
    }
    
    func aboutCreateNewAssessment() {
        self.assessmentToCreate = .create(for: UserSession.currentUser, with: nil, remarks: "", address: nil)
        showNewAssessmentModal = true
    }

    func newAssessmentModalDismissed() {
        CoreDataHelper.stack.rollback()
    }
    private func deleteInvalids() {
        for a in assessments {
            if !a.isValid() {
                CoreDataHelper.stack.delete(a)
            }
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("ass will change", showNewAssessmentModal)
        objectWillChange.send()
    }
}
