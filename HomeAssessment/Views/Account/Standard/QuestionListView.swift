//
//  QuestionListView.swift
//  tet
//
//  Created by Mengoreo on 2020/2/22.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct QuestionListView: View {
    var questions: [Question]
    
    var body: some View {
        List {
            ForEach(questions) { question in
                HStack {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("\(question.index) " + question.name)
                            .font(.headline)
                        VStack(alignment: .leading, spacing: 3) {
                            ForEach(question.getOptions()) { option in
                                Text(option.optionDescription)
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle("问题及其选项", displayMode: .inline)
    }
}
