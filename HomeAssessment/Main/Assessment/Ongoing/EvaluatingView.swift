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
                    }),
                    ActionSheet.Button.cancel(Text("取消"))
                    
                ])
            }
            NavigationLink(destination: ReportEditView(viewModel: .init(assessment)), isActive: $showEditReport) {
                Text("")
            }.hidden()
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
        .navigationBarItems(trailing: Button("分享并合并"){
            self.showShareActoin = true
        })
    }
}



