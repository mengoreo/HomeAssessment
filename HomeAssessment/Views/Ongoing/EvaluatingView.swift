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
        }
        .navigationBarTitle("\(assessment.remarks)", displayMode: .inline)
        .navigationBarItems(trailing: Group {
            if hideBackButton {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            } else {
                Text("")
            }
        })
        .navigationBarHidden(hideBackButton)
        .onAppear {
            AppStatus.update(hideTabBar: true)
        }
    }
}



