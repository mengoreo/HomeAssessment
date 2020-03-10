//
//  TabsContainer.swift
//  tet
//
//  Created by Mengoreo on 2020/2/23.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData

struct TabsContainer: View {
    @Binding var selected: Int16
    @Binding var hide: Bool
    var body: some View {
        ZStack {
        UIKitTabView([
            UIKitTabView.Tab(view:
                AssessmentListView(viewModel: .init()), title: "我的评估", image: "doc.text.magnifyingglass"),
            UIKitTabView.Tab(view:
                AccountView(user: .currentUser), title: "个人中心", image: "person")
        ], selectedIndex: $selected, hideTabBar: $hide)

            
        }
            
        .accentColor(.accentColor)
    }
}
