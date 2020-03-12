//
//  WelcomeViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/9.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import CoreData
import SwiftUI

class WelcomeViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    @Published var uiProperties = UIProperties()
    @Published var selectedTab = AppStatus.currentStatus.lastOpenedTab
    @Published var hide = AppStatus.currentStatus.hideTabBar
    @Published var signedIn = false
    @Published var needToSignIn = false

    @Published var showCombineView = false
    @Published var onDevice: Assessment? = nil
    @Published var combinedStandard: Standard? = nil
    
    private var authorisedBefore = AppStatus.authorised()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(willCombine(_:)), name: .WillCombineAssessments, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(doneCombine), name: .DoneCombineAssessments, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetCombine), name: .SceneDidEnterBackground, object: nil)
    }
    private lazy var appStatusController: NSFetchedResultsController<AppStatus> = {
        let controller = AppStatus.resultController
        controller.delegate = self
        return controller
    }()
    
    func onAppear() {
        try? appStatusController.performFetch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.updateUIProperties()
        }
    }
    
    @objc func willCombine(_ notification: Notification) {
        if let onDevice =
            notification.userInfo![UserInfoKey.onDeviceAssessment] as? Assessment,
            let combinedStandard =
            notification.userInfo![UserInfoKey.combinedStandard] as? Standard {
            self.combinedStandard?.delete() // incase multiple transfer
            self.onDevice = onDevice
            self.combinedStandard = combinedStandard
            self.showCombineView = true
        }
    }
    @objc func doneCombine() {
        showCombineView = false
        combinedStandard?.delete()
    }
    @objc func resetCombine() {
        showCombineView = false
    }
    private func updateUIProperties() {
        AppStatus.authorised() ?
            updateUIPropertiesAfterAuthorised() :
            updateUIPropertiesBeforeSigningIn()
    }
    
    private func updateUIPropertiesAfterAuthorised() {
        needToSignIn = false
        updateUIPropertiesBeforeDisplaying(
            AppStatus.currentStatus.lastOpenedTab)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.signedIn = true
            self.uiProperties.mainViewOpacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(AppStatus.currentStatus.lastOpenedTab)){
                self.uiProperties.mainViewOpacity = 1
            }
        }
    }
    private func updateUIPropertiesBeforeSigningIn() {
        self.uiProperties.mainViewOpacity = 0
        self.signedIn = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.uiProperties.iconBottomPadding = Device.height / 1.3
            self.uiProperties.iconTrailingPadding = 0
            self.uiProperties.iconScale = 0.7
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.needToSignIn = true
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if authorisedBefore != AppStatus.authorised() {
            updateUIProperties()
            authorisedBefore = AppStatus.authorised()
        }
        print("objectWillChange in welcomeview")
        objectWillChange.send()
        hide = AppStatus.currentStatus.hideTabBar
    }
    
    
    private func updateUIPropertiesBeforeDisplaying(_ tab: Int32) {
        print("updateUIForDisplayingTab \(tab)")
        if tab == 0 { // list view
            uiProperties.iconTopPadding = 13
            uiProperties.iconTrailingPadding = Device.width - 50
            uiProperties.iconBottomPadding = Device.height - 50
            uiProperties.iconOpacity = 0
            uiProperties.iconFrame.width = 20
            uiProperties.iconFrame.height = 20
        } else {
            uiProperties.iconTopPadding = 0
            uiProperties.iconTrailingPadding = 0
            uiProperties.iconBottomPadding = 0
            uiProperties.iconOpacity = 0
            uiProperties.iconFrame.width = Device.width / 2
            uiProperties.iconFrame.height = Device.width / 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // reset
            self.uiProperties = UIProperties()
        }
    }
}
