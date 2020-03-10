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
