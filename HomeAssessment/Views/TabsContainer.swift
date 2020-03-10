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
//    @ObservedObject var viewModel = TabsContainerViewModel()
//    @Binding var selected =
//    @State var hide = AppStatus.currentStatus.hideTabBar
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

//        TabBarView(tabs: [
//            .init(title: "我的评估2", systemImageName: "doc.text.magnifyingglass"),
//            .init(title: "个人中心2", systemImageName: "person")],
//            selected: $viewModel.selectedTab, hide: $viewModel.hideTabBar)
            
        }
//            .onAppear(perform: viewModel.onAppear)
  
            
//        TabView(selection: selection) {
//            AssessmentListView(viewModel: .init())
                
//                .tag(Int16(0))
//                .tabItem {
//                    Image(systemName: "doc.text.magnifyingglass")
//                    Text("我的评估")
//                }
//
//
            
//                .tag(Int16(1))
//                .tabItem {
//                    Image(systemName: "person")
//                    Text("个人中心")
//                }
//
//        }
            
        .accentColor(.accentColor)
//        .edgesIgnoringSafeArea(.top)
    }
}

//class TabsContainerViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
//    @Published var selectedTab = AppStatus.currentStatus.lastOpenedTab
//    @Published var hideTabBar = AppStatus.currentStatus.hideTabBar
//    private var hidedBefore = AppStatus.currentStatus.hideTabBar
//
//    private lazy var appStatusController: NSFetchedResultsController<AppStatus> = {
//        let controller = AppStatus.resultController
//        controller.delegate = self
//        return controller
//    }()
//
//    func onAppear() {
//        objectWillChange.send()
//        try? appStatusController.performFetch()
//        print("onAppear")
//    }
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
////        if hidedBefore != AppStatus.currentStatus.hideTabBar {
//            print("objectWillChange to \(hideTabBar)")
//        objectWillChange.send()
//
//        hideTabBar = AppStatus.currentStatus.hideTabBar
//        selectedTab = AppStatus.currentStatus.lastOpenedTab
////            hidedBefore = AppStatus.currentStatus.hideTabBar
////        }
//    }
//}
