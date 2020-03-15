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
                            NavigationLink(destination:
                                EvaluatingView(assessment: assessment)
                                    .accentColor(.accentColor)
                                    .animation(.myease)
                            ) {
                                AssessmentRowView(viewModel: .init(assessment: assessment))
                                .animation(.myease)
                                
                            }
                            .disabled(self.viewModel.updating || assessment.standard == nil)
                    }                
                }.listStyle(PlainListStyle())
                .onAppear(perform: viewModel.onAppear)
                .onDisappear {
                    AppStatus.update(hideTabBar: AppStatus.currentStatus.lastOpenedTab == 0)
                }

                Text("").hidden().sheet(isPresented: $viewModel.showNewAssessmentModal, onDismiss: viewModel.newAssessmentModalDismissed) {
                    NewEditAssessmentView(viewModel: .init(assessment: self.viewModel.assessmentToCreate!))
                        .accentColor(.accentColor)
                }
            }
            .accentColor(.accentColor)
            .navigationBarTitle("我的评估")
            .navigationBarItems(
                leading:
                    ZStack {
                        Image.icon.renderingMode(.original)
                            .resizable()
                            .frame(width: 23, height: 23, alignment: .center)
                            .opacity(self.viewModel.updating ? 0 : 1)
                        
                        HStack {
                            Spacer()
                            ActivityIndicator(isAnimating: .constant(true), style: .medium)
                            Spacer()
                        }.opacity(self.viewModel.updating ? 1 : 0)
                        
                    }
                ,trailing:
                    HStack {
                        Button(action:{}){
                            Image.ellipsisCircleFill.scaleEffect(1.3)
                        }
                        .disabled(viewModel.updating)
                        Spacer().frame(width: 20)
                        Button(action:{
                            self.viewModel.aboutCreateNewAssessment()
                        }){
//                            Image.plusCircleFill.scaleEffect(1.3)
                            Image(uiImage: UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 17), scale: .large))!)
                        }
                        .disabled(viewModel.updating)
                        .contextMenu {
                            Button("fake") {
                                self.viewModel.fakeCreate()
                            }
                        }
                    }.padding(.trailing, 10)
                )
        }
        .accentColor(.accentColor)
    }
}


