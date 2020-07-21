//
//  SceneDelegate.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var combinedStandard: Standard?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        UserSession.clear()
//        AppStatus.currentStatus.authorised = false
        
        // Create the SwiftUI view that provides the window contents.
        let welcomeView = WelcomeView(viewModel: .init())
//        let welcomeView = TabsContainer(selection: $newElderModal)
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: welcomeView)
            self.window = window
            window.makeKeyAndVisible()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willCombine(_:)), name: .WillCombineAssessments, object: nil)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            ShareDataManager.manager.handle(url)
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
//        CoreDataHelper.stack.save()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("sceneDidBecomeActive")
        let currentStyle = Int32(UIScreen.main.traitCollection.userInterfaceStyle.rawValue)
        if AppStatus.currentStatus.lastUserInterface != currentStyle {
            AppStatus.currentStatus.lastUserInterface = currentStyle
//            CoreDataHelper.stack.save()
            
            for ass in Assessment.all() {
                ass.mapPreviewNeedsUpdate = true
            }
        }
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
//        CoreDataHelper.stack.save()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        combinedStandard?.delete()
        NotificationCenter.default.post(name: .SceneDidEnterBackground, object: nil)
        CoreDataHelper.stack.saveForSceneDelegate()
    }

    @objc private func willCombine(_ notification: Notification) {
        combinedStandard = notification.userInfo![UserInfoKey.combinedStandard] as? Standard
    }
}

