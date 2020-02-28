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
    @Published var newBarTitle = "新建评估"
    
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
        newBarTitle = assessment.remarks
        showNewAssessmentModal.toggle()
    }
    
    func createNewAssessment() {
        self.assessmentToCreateOrEdit = .create(for: UserSession.currentUser, with: nil, remarks: "", address: nil)
        newBarTitle = "新建评估"
        showNewAssessmentModal.toggle()
    }

    func newAssessmentModalDismissed() {
        print("** newAssessmentModalDismissed")
        CoreDataHelper.stack.context.rollback()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
}
