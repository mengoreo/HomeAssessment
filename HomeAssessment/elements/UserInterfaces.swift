//
//  UserInterfaces.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import SwiftUI

typealias WelcomeUserInterfaceView = WelcomeUserInterface & View

protocol WelcomeUserInterface {
    func render()
}

protocol SignInUserInterface {
//    func render(newState: SignInViewState)
    func configureViewAfterLayout()
    func moveContentForDismissedKeyboard()
    func moveContent(forKeyboardFrame keyboardFrame: CGRect)
}

protocol SignUpUserInterface {
    func configureViewAfterLayout()
    func moveContentForDismissedKeyboard()
    func moveContent(forKeyboardFrame keyboardFrame: CGRect)
}
