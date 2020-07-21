//
//  StandardListView.swift
//  testCoreData
//
//  Created by Mengoreo on 2020/2/19.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData

struct StandardListView: View {
    @ObservedObject var viewModel: StandardListViewModel
    @State var showingQuestion = false
    var body: some View {
        ZStack {
            List {
                if viewModel.loading {
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                        Spacer()
                    }
                }
                ForEach(viewModel.standards){standard in
                    NavigationLink(destination: QuestionListView(questions: standard.getQuestions())) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text(standard.name)
                            Text("关联\(standard.assessments?.count ?? 0)个评估项目")
                                .font(.caption)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                    }
                }.onDelete(perform: viewModel.aboutToDelete(_:))
                
                
            }
            .listStyle(PlainListStyle())
            
            Text("").hidden().actionSheet(isPresented: $viewModel.showActionSheet) {
                ActionSheet(title: Text(self.viewModel.actionTitle), buttons: [.cancel(Text("取消")), .destructive(Text("确认"), action: self.viewModel.destructiveAction)])
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "arrow.2.circlepath.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .offset(x: -20)
                        .onTapGesture(perform: viewModel.refresh)
                        .onLongPressGesture(perform: viewModel.fakeCreate)
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .navigationBarTitle("我的标准")
    }
}

