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
                    NavigationLink(destination: ReportListView()) {
                        Text("我的评估报告")
                    }
                    NavigationLink(destination: CapturedPhotosView()) {
                        Text("我的照片")
                    }
                    NavigationLink(destination: StandardListView(viewModel: .init(user: .currentUser))
                        .accentColor(.accentColor)) {
                            Text("可用的标准")
                    }
                }
                
                Section {
                    Button("退出登录") {
                        AppStatus.update(authorised: false)
                    }
                }
            }
                .navigationBarTitle("\(user.name)")
            .onAppear {
                print("account appere")
                AppStatus.update(lastOpenedTab: 1, hideTabBar: false)
            }.onDisappear {
                AppStatus.update(hideTabBar: AppStatus.currentStatus.lastOpenedTab == 1)
            }
        }
        
    }
}
