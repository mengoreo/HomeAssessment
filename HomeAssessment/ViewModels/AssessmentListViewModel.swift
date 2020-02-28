//
//  AssessmentListViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/18.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData
import SwiftUI

class AssessmentListViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    var assessments: [Assessment] {
        return assessmentController.fetchedObjects?.filter{$0.user == .currentUser} ?? []
    }
    @Published var showNewAssessmentModal = false
    @Published var updating = false
    private lazy var assessmentController: NSFetchedResultsController<Assessment> = {
        let controller = Assessment.resultController
        controller.delegate = self
        return controller
    }()
    
    var assessmentToCreateOrEdit: Assessment? = nil
    
    func onAppear() {
        print("** test create")
        objectWillChange.send()
        try? assessmentController.performFetch()
    }
    
    func update(_ assessment: Assessment) {
        assessmentToCreateOrEdit = assessment
        showNewAssessmentModal.toggle()
    }
    
    func createNewAssessment() {
        self.assessmentToCreateOrEdit = .create(for: UserSession.currentUser, with: nil, remarks: "", address: nil)
        showNewAssessmentModal.toggle()
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
}
