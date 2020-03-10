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
        return assessmentController.fetchedObjects?.filter{$0.user == .currentUser}
//            .filter{$0.isValid()}
            ?? []

    }
//    @Published var assessments = Assessment.all().filter{$0.user == .currentUser}.filter{$0.isValid()}
    @Published var showNewAssessmentModal = false
    @Published var updating = false
    
//    override init() {
//        super.init() // required for observing changes after scene become active
////        print("objectWillChange in asslist")
////        objectWillChange.send()
////        try? assessmentController.performFetch()
////        assessments =  // precondition error prevented?
//    }
    
    private lazy var assessmentController: NSFetchedResultsController<Assessment> = {
        let controller = Assessment.resultController
        controller.delegate = self
        return controller
    }()
    
    var assessmentToCreate: Assessment? = nil
    
    func onAppear() {
        print("asslist will appear")
        objectWillChange.send() // perform fetch in welcom view
        print("elders:", Elder.all())
        print("contact:", Contact.all())
        try? assessmentController.performFetch()
        AppStatus.update(lastOpenedTab: 0, hideTabBar: false)
//        deleteInvalids()
    }
    
    func fakeCreate() {
        let a = Assessment.create(for: .currentUser, with: Standard.all().first ?? nil, remarks: "fake", address: nil)
        _ = Contact.create(for: a, name: "fake", phone: "177")
        Elder.create(for: a, name: "fake", heightInCM: 100, status: "fake")
        a.address = MKPlacemark(coordinate: .init(latitude: 17.978733, longitude: -0.791016))
        objectWillChange.send()
    }
    
    func aboutCreateNewAssessment() {
//        assessmentController.delegate = nil
//        CoreDataHelper.stack.save()
        self.assessmentToCreate = .create(for: UserSession.currentUser, with: nil, remarks: "", address: nil)
        showNewAssessmentModal = true
    }

    func newAssessmentModalDismissed() {
        CoreDataHelper.stack.rollback()
        print("** newAssessmentModalDismissed")
//        deleteInvalids()
//        CoreDataHelper.stack.context.rollback()
//        objectWillChange.send() // required??
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
//        objectWillChange.send()
//        try? assessmentController.performFetch()
    }
}
