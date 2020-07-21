//
//  AssessmentRowView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/29.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import MapKit
struct AssessmentRowView: View {
    @ObservedObject var viewModel: AssessmentRowViewModel
    var body: some View {
        
        ZStack {
            NavigationLink(destination:
                EvaluatingView(assessment: viewModel.assessment)
                    .accentColor(.accentColor)
                    .animation(.myease)
            ) {
                HStack(alignment: .center) {
                    
                    ZStack {
                        Button(action:viewModel.showMap) {
                            ZStack {
                                Image(uiImage: self.viewModel.mapPreview).resizable()
                                ActivityIndicator(isAnimating: $viewModel.needUpdatePreview, style: .medium, color: .tintColor)
                            }
                        }
                        .buttonStyle(ImageButtonStyle(width: 50, height: 50))
                        
                        Text("").hidden().sheet(isPresented: $viewModel.showMapModal) {
                            NavigationView {
                                CurrentLocationView(placemark: self.viewModel.assessment.address!)
                                    .edgesIgnoringSafeArea(.all) .navigationBarTitle("\(self.viewModel.assessment.remarks)",
                                        displayMode: .inline)
                            }
                        }
                    }
        //
                    VStack(alignment: .leading, spacing: 7) {

                        Text(viewModel.assessment.remarks)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .font(.body)
                            .truncationMode(.tail)
                            .fixedSize(horizontal: false, vertical: true)

                        VStack(alignment: .leading, spacing: 3) {
                            if viewModel.assessment.reportData != nil {
                                Text("已完成")
                                    .font(.footnote)
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                            } else {
                            Text("评估进度: \(String(format: "%.2f", viewModel.assessment.progress))%")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                            }
                            if viewModel.assessment.standard == nil {
                                Text("<因未关联评估标准而无法进行该评估>")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(UIColor.systemRed))
                                    .bold()
                            }
                        }

                    }
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 1) {
                        HStack(spacing: 3) {
                            Text((viewModel
                                .assessment
                                .dateUpdated ?? Date())
                                .relevantString
                                .split(separator: " ")
                                .joined(separator: "\n")
                            ).font(.system(size: 10))
                        }
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    
                }
            }
            .disabled(viewModel.assessment.standard == nil)
            Text("").hidden().sheet(isPresented: $viewModel.showEditModel, onDismiss: viewModel.editModalWillDismiss) {
                NewEditAssessmentView(viewModel: .init(assessment: self.viewModel.assessment))
                    .accentColor(.accentColor)
            }
            
            Text("").hidden().actionSheet(isPresented: $viewModel.showWarning) {
                ActionSheet(title: Text("\(self.viewModel.warningMessage)"), message: nil, buttons: [.cancel(Text("取消")), .destructive(Text("确定"), action: self.viewModel.warningDestructiveAction)])
            }
            Text("").hidden().sheet(isPresented: $viewModel.shareModal) {
                AirDropShareView(items: self.viewModel.sharedItems)
            }
            
        }
//        .contextMenu {
//            Button(action: {
////                CoreDataHelper.stack.save()
//                self.viewModel.aboutToShare()
//            }) {
//                Text("分享")
//                Image(systemName: "chevron.right.circle")
//            }
//            
//            Button(action: {
//                self.viewModel.showEditModel = true
//            }) {
//                Text("编辑")
//                Image(systemName: "chevron.right.circle")
//            }
//            
//            Button(action: {
//                self.viewModel.aboutToDelete()
//            }) {
//                Text("删除❗️")
//                Image(systemName: "trash.circle")
//            }
//        }
        
        .padding(.vertical, 3)
        .frame(height: 70)
        .onAppear(perform: viewModel.onAppear)
        
    }
}


