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
    
    @State var showQuestions = false
    
    var body: some View {
        NavigationView {
            
            List {
                // MARK: - List body
                ForEach(self.viewModel.standards) { standard in
                    
                    Button(action:{
                        if AppStatus.currentStatus.lastOpenedTab == 0 {
                            self.selected.wrappedValue = standard
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.showQuestions = true
                            
                        }
                    }) {
                        ZStack {
                            NavigationLink(destination: QuestionListView(questions: standard.getQuestions()), isActive: self.$showQuestions) {
                                Text("")
                            }.hidden()
                            
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
                        }
                        .padding(.vertical, 10)
                        .contextMenu {
                            if !standard.getQuestions().isEmpty {
                                Button(action: {
                                    self.showQuestions = true
                                }) {
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
        
        print("objectWillChange in standardlist")
        objectWillChange.send()
        try? standardController.performFetch()
    }
    
    func fakeCreate() {
        let fstandard = Standard.create(for: user, name: "居家适老化评估标准", index: 0, uuidString: UUID().uuidString)
        let q1 = Question.create(for: fstandard, index: 1, name: "照光够明亮，方便老人可以看清屋内物品及家具、通道等位置", measurable: false, uuidString: UUID().uuidString)
        let q2 = Question.create(for: fstandard, index: 2, name: "屋内的电灯开关都有明显的特殊设计（例如：有开关外环显示灯或萤黄贴条）", measurable: false, uuidString: UUID().uuidString)
        let q3 = Question.create(for: fstandard, index: 3, name: "光线强度不会让老年人感到眩晕或看不清物品位置", measurable: false, uuidString: UUID().uuidString)
        let q4 = Question.create(for: fstandard, index: 4, name: "门距够宽，可让老年人容易进出", measurable: true, uuidString: UUID().uuidString)
        
        Option.create(for: q1, index: 1, optionDescription: "白天需要开灯才够明亮", from_val: 0, to_val: 0, vote: 1, suggestion: "适当增加室内亮度", uuidString: UUID().uuidString)
        Option.create(for: q1, index: 2, optionDescription: "白天需要开灯才够明亮，但通常不开灯", from_val: 0, to_val: 0, vote: 2, suggestion: "适当增加室内亮度", uuidString: UUID().uuidString)
        Option.create(for: q1, index: 3, optionDescription: "白天不需要开灯，照光就足够明亮", from_val: 0, to_val: 0, vote: 3, suggestion: "", uuidString: UUID().uuidString)
        
        Option.create(for: q2, index: 1, optionDescription: "无明显特殊设计", from_val: 0, to_val: 0, vote: 1, suggestion: "在开关处增加标记", uuidString: UUID().uuidString)
        Option.create(for: q2, index: 2, optionDescription: "有明显特殊设计", from_val: 0, to_val: 0, vote: 2, suggestion: "", uuidString: UUID().uuidString)
        
        Option.create(for: q3, index: 1, optionDescription: "光线较弱，看不清物品", from_val: 0, to_val: 0, vote: 1, suggestion: "适当增加室内的进光量", uuidString: UUID().uuidString)
        Option.create(for: q3, index: 2, optionDescription: "光线较强，使人感到眩晕", from_val: 0, to_val: 0, vote: 2, suggestion: "适当减弱室内的进光量", uuidString: UUID().uuidString)
        Option.create(for: q3, index: 3, optionDescription: "光线强度适中，使人眼睛舒适且能看清物品", from_val: 0, to_val: 0, vote: 3, suggestion: "", uuidString: UUID().uuidString)
        
        Option.create(for: q4, index: 1, optionDescription: "", from_val: 0, to_val: 90, vote: 1, suggestion: "门距太窄", uuidString: UUID().uuidString)
        Option.create(for: q4, index: 2, optionDescription: "", from_val: 90, to_val: 100, vote: 2, suggestion: "门距适当加宽距离", uuidString: UUID().uuidString)
        Option.create(for: q4, index: 3, optionDescription: "", from_val: 100, to_val: 99999, vote: 3, suggestion: "", uuidString: UUID().uuidString)
        
    }
    func refresh() {
        loading = true
        APIDataManager.fetchTask(.standard, with: user.token, completionHandler: handle(data:response:error:for:), for: user)
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
    
    func cancelDelete() {
        actionTitle = ""
        showActionSheet = false
        destructiveAction = {}
    }
    
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
            
            APIDataManager.fetchTask(.question(standard: standardJ.index), with: curUser.token, completionHandler: handleQuestion(data:response:error:for:), for: standard)
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
            
            APIDataManager.fetchTask(.option(standard: Int(standard.index), question: questionJ.index), with: standard.user.token, completionHandler: handleOption(data:response:error:for:), for: question)
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
