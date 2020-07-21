//
//  EvaluatingView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/7.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct EvaluatingView: View {
    @State var hideBackButton = false
    var assessment: Assessment
    @State var showShareActoin = false
    @State var showEditReport = false
    @State var share = false
    @State var alreadyShared = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Group {
            List {
                ForEach(assessment.standard!.getQuestions()) {question in
                    QuestionRowView(
                        viewModel: .init(assessment: self.assessment,
                                         question: question,
                                         hidehideNavigationBarBackButton: self.$hideBackButton
                        ))
                }
            }
            
            Text("").hidden().actionSheet(isPresented: $showShareActoin) {
                ActionSheet(title: Text("即将分享当前评估与同事进行合并，确定分享吗？"), buttons: [
                    ActionSheet.Button.destructive(Text("跳过"), action: {
                        self.showEditReport = true
                    }),
                    ActionSheet.Button.default(Text("分享"), action: {
                        self.share = true
                        self.presentationMode.wrappedValue.dismiss()
                    }),
                    ActionSheet.Button.cancel(Text("取消"))
                    
                ])
            }
            NavigationLink(destination: ReportEditView(viewModel: .init(assessment)), isActive: $showEditReport) {
                Text("")
            }.hidden()
            
            Text("").hidden().sheet(isPresented: $share) {
                AirDropShareView(items: [try! ShareDataManager.manager.compressAndShare(self.assessment)])
            }
        }.edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("\(assessment.remarks)", displayMode: .inline)
//        .navigationBarItems(trailing: Group {
//            if hideBackButton {
//                ActivityIndicator(isAnimating: .constant(true), style: .medium)
//            } else {
//                Text("")
//            }
//        })
        .navigationBarHidden(hideBackButton)
            .navigationBarItems(trailing: Button(assessment.reportData != nil ? "编辑报告" :"下一步"){
                if self.assessment.reportData != nil {
                    self.showEditReport = true
                } else {
                    self.showShareActoin = true
                }
        })
    }
}



