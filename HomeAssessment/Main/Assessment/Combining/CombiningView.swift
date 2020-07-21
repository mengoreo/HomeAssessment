//
//  CombiningView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData

fileprivate var readyQuestions = 0 {
    didSet {
        print("didset readyQuestions", readyQuestions)
    }
}

class CombiningViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    let onDevice: Assessment?
    let combinedStandard: Standard?
    @Published var updating = false
    @Published var showEditReport = false
    // MARK: - CombiningViewModel
    init(onDevice: Assessment?, combinedStandard: Standard?) {
        self.onDevice = onDevice
        self.combinedStandard = combinedStandard
        super.init()
        // MARK: - 监听 Question 的变化
        Question.resultController.delegate = self
        try? Question.resultController.performFetch()
    }
    private func doneCombine() {
        NotificationCenter.default.post(name: .DoneCombineAssessments, object: nil)
    }
    
    var available: Bool {
        onDevice != nil && combinedStandard != nil
    }
    var questions: [Question] {
        Array(combinedStandard?.questions ?? [])
    }
    var saveButtonDisabled: Bool {
        for q in questions {
            if q.options!.count > 1 { // need to select
                return true
            }
        }
        return false
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("** questions will change in combine")
        objectWillChange.send()
    }
    
    func cancel() {
        updating = true
        doneCombine()
        updating = false
    }
    func done() {
        updating = true
        for q in questions {
            onDevice?.selectedOptions[q.uuid] = q.options?.first?.uuid // only one
        }
//        doneCombine()
        
        showEditReport = true
        updating = false
    }
    
}
struct CombiningView: View {
    @ObservedObject var viewModel: CombiningViewModel
    @State var readyQs:Int = 0
    var body: some View {
        NavigationView {
            Group {
            List {
                if viewModel.questions.isEmpty {
                    Text("没有需要合并的条目")
                }
                ForEach(viewModel.questions) { question in
                    CombineQuestionRowView(viewModel: .init(question: question))
                }
            }
                if viewModel.available {
                    NavigationLink(destination: ReportEditView(viewModel: .init(viewModel.onDevice!)), isActive: $viewModel.showEditReport) {
                        Text("")
                    }.hidden()
                }
            }
            .navigationBarTitle("评估合并", displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: viewModel.cancel) {
                        ZStack {
                            Text("取消")
                            ActivityIndicator(isAnimating: self.$viewModel.updating, style: .medium)
                        }
                    }
                    ,
                                    trailing:
                    Button(action: viewModel.done) {
                        ZStack {
                            Text("下一步")
                            ActivityIndicator(isAnimating: self.$viewModel.updating, style: .medium)
                        }
                    }.disabled(viewModel.saveButtonDisabled)
                )
        }
    }
    
}

struct CombineQuestionRowView: View {
    @ObservedObject var viewModel: CombineQuestionRowViewModel
    var body: some View {
        Section(header:
            HStack {
                Text("\(viewModel.question.name)")
                if viewModel.showUndoButton {
                    Spacer()
                    Button(action: viewModel.undo) {
                        Image(systemName: "arrow.uturn.left")
                    }
                    .accentColor(.darkGreen)
                }
            }
        ) {
            ForEach(viewModel.options) { option in
                HStack {
                    CombineOptionRowView(option: option)
                    
                    if self.viewModel.showDeleteButton {
                        Spacer()
                        Button(action: {
                            self.viewModel.remove(option)
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.lightGreen)
                        }
                    }
                }
            }
        }
    }
}

class CombineQuestionRowViewModel: ObservableObject {
    let question: Question
    init(question: Question) {
        self.question = question
        print("CombineQuestionRowViewModel inited")
    }
    
    var showDeleteButton: Bool {
        options.count > 1
    }
    
    var showUndoButton: Bool {
        ShareDataManager.manager.removedOptions[question.uuid] != nil
    }
    var options: [Option] {
        Array(question.options ?? [])
    }
    
    // MARK: - CombineQuestionRowViewModel
    func remove(_ option: Option) {
        option.setValue(nil, forKey: "question")
        ShareDataManager.manager.removedOptions[question.uuid] = option
    }
    func undo() {
        objectWillChange.send()
        let option = ShareDataManager.manager.removedOptions.removeValue(forKey: question.uuid)
        option?.question = question
    }
}

struct CombineOptionRowView: View {
    let option: Option
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 5) {
                Text(option.description)
                Text(option.suggestion)
                    .foregroundColor(
                        Color(UIColor.tertiaryLabel)
                    )
            }
        }
    }
    
}
