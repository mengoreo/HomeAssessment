//
//  AccountView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/5.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    @State var showStandards = false
    var user: UserSession
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: Text("")) {
                        Text("我的评估报告")
                    }
                    NavigationLink(destination: Text("")) {
                        Text("我的照片")
                    }
                    Button(action:{
                        self.showStandards.toggle()
                    }) {
                        HStack {
                            Text("可用的标准")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .imageScale(.small)
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                        }
                        .sheet(isPresented: self.$showStandards) {
                            StandardListView(viewModel: .init(user: .currentUser), selected: .constant(nil))
                                .accentColor(.accentColor)
                        }
                    }.accentColor(Color(UIColor.label))
                }
                
                Section {
                    Button("退出登录") {
                        AppStatus.update(authorised: false)
                    }
                }
            }
//            .listStyle(GroupedListStyle())
                .navigationBarTitle("\(user.name)")
        }
        .onAppear {
            AppStatus.update(lastOpenedTab: 1)
        }
    }
}
