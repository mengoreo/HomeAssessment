//
//  StandardListView.swift
//  testCoreData
//
//  Created by Mengoreo on 2020/2/19.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct StandardListView: View {
    @ObservedObject var viewModel: StandardListViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var selected: Binding<Standard?>
    
    var body: some View {
        NavigationView {
            
            List {
                // MARK: - List body
                ForEach(self.viewModel.standards) { standard in
                    
                    Button(action:{
                        self.selected.wrappedValue = standard
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("\(standard.index) " + standard.name).font(.body)
                                Text("于 \(standard.dateString) 更新")
                                    .font(.footnote)
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 7) {
                                Text("共 \(standard.getQuestions().count) 个问题")
                                    .font(.footnote)
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                Text("关联 \(standard.getAssessments().count) 个评估")
                                    .font(.footnote)
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                            }
                            if self.selected.wrappedValue != nil && self.selected.wrappedValue == standard {
                                Spacer().frame(width: 3)
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                            }
                        }
                        .padding(.vertical, 10)
                        .contextMenu {
                            if !standard.getQuestions().isEmpty {
                                NavigationLink(destination: QuestionListView(questions: standard.getQuestions())) {
                                    Text("查看问题")
                                    Image(systemName: "arrow.right.circle")
                                }
                            }
                            Button(action:{
                                self.viewModel.aboutToDelete(standard)
                            }) {
                                Text("删除")
                                Image(systemName: "trash.circle")
                            }
                        }
                    }
                }
                .actionSheet(isPresented: self.$viewModel.showActionSheet) {
                    ActionSheet(title: Text(self.viewModel.actionTitle),
                                buttons: [.cancel(Text("取消"), action: {self.viewModel.cancelDelete()}),
                                          .destructive(Text("确定"), action: {
                                            self.viewModel.destructiveAction()
                                          })]
                    )
                }
            }
            .onAppear(perform: self.viewModel.onAppear)

            // MARK: - navigation bar appeareance
            .navigationBarTitle("我的标准", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.viewModel.refresh()
                }) {
                    if self.viewModel.loading {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    } else {
                        Image(systemName: "arrow.2.circlepath.circle.fill")
                            .imageScale(.large)
                    }
                }.contextMenu {
                    Button(action: {
                        self.viewModel.fakeCreate()

                    }) {
                        Text("Fake")
                        Image(systemName: "trash.circle")
                    }
                }
                
            )
                
        }
    }
    
}

// MARK: - view model
class StandardListViewModel: NSObject, ObservableObject {
    var user: UserSession
    private lazy var standardController: NSFetchedResultsController<Standard> = {
        let controller = Standard.resultController
        controller.delegate = self
        return controller
    }()
    
    init(user: UserSession) {
        self.user = user
    }
    
    @Published var showActionSheet = false
    @Published var actionTitle = ""
    @Published var destructiveAction: () -> Void = {}
    @Published var searchText = ""
    
    @Published var loading: Bool = false
    private var offsetsToDelete = IndexSet()
    
    var standards: [Standard] {
        return standardController.fetchedObjects?.filter{$0.user == user}.filter{searchText.isEmpty ? true : ($0 as Standard).name.localizedStandardContains(self.searchText)
        } ?? []
    }
    
    func onAppear() {
        objectWillChange.send()
        try? standardController.performFetch()
    }
    
    func fakeCreate() {
        _ = Standard.create(for: user, name: "fake", index: 0, uuidString: UUID().uuidString)
    }
    func refresh() {
        loading = true
        DataFetcher.fetchTask(.standard, with: user.token, completionHandler: handle(data:response:error:for:), for: user)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // in case no response
            self.loading = false
        }
    }
    
    func aboutToDelete(_ standard: Standard) {
        var message = standard.getAssessments().map {"「评估项目: \($0.remarks)」"}.joined(separator: "和")
        if !message.isEmpty {
            message = message + "正在使用「\(standard.name)」。❗️删除之后，这些评估进度将会被重置❗️\n"
        }
        message += "确定删除「\(standard.name)」吗?"
        
        actionTitle = message
        showActionSheet = true
        destructiveAction = standard.delete
    }
    
//    func aboutToDelete(at offsets: IndexSet) {
////        let offsets: IndexSet = [0, 1]
//        var message = offsets.map{
//                let assessmentRemarks = standards[$0].getAssessments().map {"「评估项目: \($0.remarks)」"}.joined(separator: "和")
//                if !assessmentRemarks.isEmpty {
//                    return assessmentRemarks + "正在使用「\(standards[$0].name)」"
//                }
//                return ""
//            }.joined(separator: ";\n")
//        if !message.isEmpty {
//            message = message + "\n❗️删除之后，对应评估将不能继续进行❗️" + "\n\n确定删除\(offsets.map{"「\(standards[$0].name)」"}.joined(separator: "和"))吗?"
//        } else {
//            message = "确定删除\(offsets.map{"「\(standards[$0].name)」"}.joined(separator: "和"))吗?"
//        }
//
//
//
//        actionTitle = message
//        offsetsToDelete = offsets
//        showActionSheet = true
//        destructiveAction = deleteStandard
//
//    }
//    func aboutToDeleteAll() {
//        actionTitle = "Delete all standards?"
//        showActionSheet = true
//        destructiveAction = clearStandards
//    }
    func cancelDelete() {
        actionTitle = ""
        showActionSheet = false
        destructiveAction = {}
    }
//    func deleteStandard() {
//        for index in self.offsetsToDelete {
//            standards[index].delete()
//        }
//    }
//    func clearStandards() {
//        Standard.clear()
//    }
    
    // MARK: - handle json data
    private func handle(data: Data, response: URLResponse, error: Error?, for parent: NSManagedObject) {
        if error != nil {
            print("*** error in handle")
            return
        }
        guard let standardsJSON = try? JSONDecoder().decode(StandardsJSON.self, from: data)
        else {
            print("*** decode error")
            return
        }
        guard let curUser = parent as? UserSession else {
            print("** no parent")
            return
        }
        for standardJ in standardsJSON {
            let standard = Standard.create(for: curUser, name: standardJ.name, index: standardJ.index, uuidString: standardJ.id)            
            
            DataFetcher.fetchTask(.question(standard: standardJ.index), with: curUser.token, completionHandler: handleQuestion(data:response:error:for:), for: standard)
        }
    }
    private func handleQuestion(data: Data, response: URLResponse, error: Error?, for parent: NSManagedObject) {
        if error != nil {
            print("*** error in handle")
            return
        }
        guard let questionsJSON = try? JSONDecoder().decode(QuestionsJSON.self, from: data), let standard = parent as? Standard else {
            fatalError("questions decode error")
        }
        for questionJ in questionsJSON {
             let question = Question.create(for: standard, index: Int32(questionJ.index), name: questionJ.title, measurable: questionJ.isMeasurable, uuidString: questionJ.id)
            
            DataFetcher.fetchTask(.option(standard: Int(standard.index), question: questionJ.index), with: standard.user.token, completionHandler: handleOption(data:response:error:for:), for: question)
        }
    }
    
    private func handleOption(data: Data, response: URLResponse, error: Error?, for parent: NSManagedObject) {
        if error != nil {
            print("*** error in handle")
            return
        }
        guard let optionsJSON = try? JSONDecoder().decode(OptionsJSON.self, from: data), let question = parent as? Question else {
            fatalError("questions decode error")
        }
        for optionJ in optionsJSON {
            Option.create(for: question, index: Int32(optionJ.index), optionDescription: optionJ.text, from_val: optionJ.fromVal, to_val: optionJ.toVal, vote: optionJ.vote, suggestion: optionJ.suggestion, uuidString: optionJ.id)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.loading = false
        }
    }
}

extension StandardListViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("standard will change")
        objectWillChange.send()
    }
    
}
