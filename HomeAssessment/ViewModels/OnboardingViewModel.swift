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
    @Published var signInViewModal = false
    @Published var signUpViewModal = false
    
    var authorised = false
    var displayHome = false    
    var iconProperties = IconProperties()
    var buttonProperties = ButtonProperties()
    
    func updateIcon() {
        if self.authorised {
            iconProperties.topPadding = 0
            iconProperties.opacity = 0
            iconProperties.frame.width = 1000
            iconProperties.frame.height = 1000
        } else if (self.signInViewModal || self.signUpViewModal) {
            iconProperties.topPadding = Device.height / 10
            iconProperties.bottomPadding = Device.height / 10
            iconProperties.opacity = 1
            iconProperties.topPadding = Device.height / 10
            iconProperties.frame = CGSize(width: Device.width / 4, height: Device.width / 4)
        } else {
            iconProperties.topPadding = Device.height / 7
            iconProperties.opacity = 1
            iconProperties.frame = CGSize(width: Device.width / 2, height: Device.width / 2)
        }
    }
    
    func updateView() {
        updateIcon()
    }
    func showSignInView() {
        self.signInViewModal = true
        self.signUpViewModal = false
    }
    
    func showSignUpView() {
        self.signUpViewModal = true
        self.signInViewModal = false
    }
    
    func showWelcom() {
        self.signUpViewModal = false
        self.signInViewModal = false
        self.displayHome = self.authorised
        updateView()
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

struct IconProperties {
    var topPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
    var opacity: Double = 1
    var frame = CGSize(width: Device.width / 2, height: Device.width / 2)
    
}

struct ButtonProperties {
    var bottomPadding: CGFloat = 0
}
