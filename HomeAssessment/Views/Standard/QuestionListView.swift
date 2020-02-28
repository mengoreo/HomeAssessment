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
                    Text("\(question.index)")
                    VStack(alignment: .leading) {
                        Text(question.name).font(.headline)
                        ForEach(question.getOptions()) { option in
                            Spacer()
                            Text(option.optionDescription)
                        }
                    }
                }
            }
        }.navigationBarTitle("问题及其选项", displayMode: .inline)
    }
}
