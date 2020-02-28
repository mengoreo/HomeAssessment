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
                        Button(action:{
                            self.viewModel.update(assessment)
                        }){
                            VStack(alignment: .leading) {
                                Text(assessment.remarks)
                                Spacer().frame(height: 3)
                                Text("\(assessment.standard?.name ?? "No Standard")")
                                Text("elders: \(assessment.getElders().count)")
                            }
                        }
                    }.onDelete(perform: {(offsets) in
                        for index in offsets {
                            self.viewModel.assessments[index].delete()
                        }
                    })
                }.onAppear(perform: viewModel.onAppear)

                Text("").hidden().sheet(isPresented: $viewModel.showNewAssessmentModal, onDismiss: viewModel.newAssessmentModalDismissed) {
                    NewEditAssessmentView(viewModel: .init(assessment: self.viewModel.assessmentToCreateOrEdit!), barTitle: self.viewModel.newBarTitle)
                        .accentColor(.accentColor)
                }
            }
            .navigationBarTitle("我的评估")
            .navigationBarItems(
                leading:
                    Image.icon.resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                ,trailing:
                    HStack {
                        Button(action:{}){
                            Image.ellipsisCircleFill
                        }
                        Spacer().frame(width: 20)
                        Button(action:{
                            self.viewModel.createNewAssessment()
                        }){
                            Image.plusCircleFill
                        }
                    }
                )
        }
        .accentColor(.accentColor)
    }
}

