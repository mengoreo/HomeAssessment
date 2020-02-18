//
//  WelcomeViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/9.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var signInUpViewModal = false
    
    var authorised = false
    var displayHome = false
    @Published var uiProperties = UIProperties()
    
    func updateView() {
        if authorised { // show assessment list
            uiProperties.iconTopPadding = 13
            uiProperties.iconTrailingPadding = Device.width - 50
            uiProperties.iconOpacity = 0
            uiProperties.iconFrame.width = 20
            uiProperties.iconFrame.height = 20
        }
        else if signInUpViewModal { // show sig in/up
            uiProperties.iconTopPadding = Device.height / 10
            uiProperties.iconBottomPadding = Device.height / 10
            uiProperties.buttonBottomPadding = 23
            uiProperties.iconOpacity = 1
            uiProperties.iconFrame = CGSize(width: Device.width / 4, height: Device.width / 4)
        }
        else {
            uiProperties.iconTopPadding = Device.height / 7
            uiProperties.iconTrailingPadding = 0
            uiProperties.buttonBottomPadding = 23
            uiProperties.iconOpacity = 1
            uiProperties.iconFrame = CGSize(width: Device.width / 2, height: Device.width / 2)
        }
    }
    
    func showSignInUpView() {
        self.signInUpViewModal = true
    }
    
    func showWelcom() {
        self.signInUpViewModal = false
        self.displayHome = self.authorised
        updateView()
    }
    
    func readyForAuthorising() {
        print("*** hiding buttons")
        uiProperties.iconOpacity = 0.3
        uiProperties.buttonBottomPadding = -100
    }
    
    func readyForErrors() {
        print("*** showing buttons")
        uiProperties.iconOpacity = 1
        uiProperties.buttonBottomPadding = 23
    }
}

struct Device {
    public static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    public static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    public static var rotation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
}

struct UIProperties {
    var iconTopPadding: CGFloat = 0
    var iconBottomPadding: CGFloat = 0
    var iconTrailingPadding: CGFloat = 0
    var iconOpacity: Double = 1
    var iconFrame = CGSize(width: Device.width / 2, height: Device.width / 2)
    var buttonBottomPadding: CGFloat = 0
    
}
