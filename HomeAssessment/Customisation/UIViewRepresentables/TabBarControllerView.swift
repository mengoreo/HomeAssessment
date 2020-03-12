//
//  TabBarControllerView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
import SwiftUI
import UIKit

struct TabBarController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
//    var selectedIndex: Binding<Int16>
    @Binding var selectedIndex: Int32
    @Binding var hideTabBar: Bool
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = Int(selectedIndex)
        return tabBarController
    }

    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        tabBarController.selectedIndex = Int(selectedIndex)
        if hideTabBar {
            tabBarController.tabBar.hide()
        } else {
            tabBarController.tabBar.show()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: TabBarController

        init(_ tabBarController: TabBarController) {
            self.parent = tabBarController
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            parent.selectedIndex = Int32(tabBarController.selectedIndex)
        }
    }
}


