//
//  AssessmentListView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct AssessmentListView: View {
    @ObservedObject var viewModel: AssessmentListViewModel
    
    var body: some View {
        
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.assessments) {assessment in
                        AssessmentRowView(viewModel: .init(assessment: assessment))
                            .contextMenu {
                                Button(action: {
                                    self.viewModel.aboutToEdit(assessment)
                                }) {
                                    Text("编辑")
                                    Image(systemName: "chevron.right.circle")
                                }
                                Button(action: {
                                    self.viewModel.aboutToDelete(assessment)
                                }) {
                                    Text("删除❗️")
                                    Image(systemName: "trash.circle")
                                }
                            }
                    }
                }
                .onAppear(perform: viewModel.onAppear)

                Text("").hidden().sheet(isPresented: $viewModel.showNewAssessmentModal, onDismiss: viewModel.newAssessmentModalDismissed) {
                    NewEditAssessmentView(viewModel: .init(assessment: self.viewModel.assessmentToCreateOrEdit!), barTitle: "新建评估")
                        .accentColor(.accentColor)
                }
                .actionSheet(isPresented: $viewModel.showWarning) {
                    ActionSheet(title: Text("\(self.viewModel.warningMessage)"), message: nil, buttons: [.cancel(Text("取消")), .destructive(Text("确定"), action: self.viewModel.warningDestructiveAction)])
                }
            }
            .accentColor(.accentColor)
            .navigationBarTitle("我的评估")
            .navigationBarItems(
                leading:
                    Image.icon.resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                ,trailing:
                    HStack {
                        Button(action:{}){
                            Image.ellipsisCircleFill.scaleEffect(1.3)
                        }
                        Spacer().frame(width: 20)
                        Button(action:{
                            self.viewModel.aboutCreateNewAssessment()
                        }){
                            Image.plusCircleFill.scaleEffect(1.3)
                        }
                    }
                )
        }
        .accentColor(.accentColor)
    }
}

