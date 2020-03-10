//
//  SignInViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import SwiftUI


class SignInViewModel: ObservableObject {
    
//    private var welcomViewModel: OnboardingViewModel!
    private var debugStringHeader = "** SignInViewModel:"
    
    @Published var name: String = AppStatus.currentStatus.lastUserName
    @Published var password: String = ""
    @Published var errorMessage: ErrorMessage!
    @Published var appearance = SignInViewAppearence()
    @Published var status = SignInViewStatus()

    
    func onAppear() {
        name = AppStatus
            .currentStatus
            .lastUserName
        password = ""
        if name.isEmpty {
            focusOnNameField()
        } else {
            focusOnPasswordField()
        }
        
    }
    func willEditNameField() {
        focusOnNameField()
    }
    func willEndEditingNameField() {
        focusOnPasswordField()
    }
    func willEndEditingPasswordField() {
        appearance
            .passwordFieldScale = 0.8
        appearance
            .passwordFieldOpacity = 0
        
        if !status.editingNameField {
            authorise()
        }
    }
    
    func toggleShowPassword() {
        status.showPassword.toggle()
        if status.showPassword {
            appearance.eyeSymbol = "eye.slash.fill"
        } else {
            appearance.eyeSymbol = "eye.fill"
        }
    }
        
    func handleError() {
        switch errorMessage.type {
        case .signInError(.nameField):
            focusOnNameField()
            break
        case .signInError(.passwordField):
            focusOnPasswordField()
            break
        default:
            break
        }
    }
    
    func nameV(_ d: ViewDimensions) -> CGFloat {
        if !status.editingNameField && !status.editingPasswordField {
            return 0
        } else if status.editingNameField {
            return d[.bottom] + 10
        } else { // editingPasswordField
            return d[.top] - 10
        }
    }


    func passwordV(_ d: ViewDimensions) -> CGFloat {
        if !status.editingNameField && !status.editingPasswordField {
            return 0
        } else if status.editingNameField {
            return d[.top] - 10
        } else { // editingPasswordField
            return d[.bottom] + 10
        }
    }
    
    
    private func readyForAuthorise() {
        DispatchQueue.main.async {
            self.status.authorisingUser = true
            self.appearance.activityIndicatorOpacity = 1
            self.appearance.fieldsOpacity = 0
        }
    }
    private func doneAuthorising() {
        DispatchQueue.main.async {
            self.status.authorisingUser = false
            self.appearance.activityIndicatorOpacity = 0
            self.appearance.fieldsOpacity = 1
        }
    }
    private func authorise() {
        readyForAuthorise()
        UserSession.performCreate(name: name, password: password) { errorMessage in
            guard errorMessage == nil else {
                self.showError(errorMessage!)
                self.doneAuthorising()
                return
            }
            self.doneAuthorising()
            CoreDataHelper.stack.save()
        }
    }
    private func focusOnNameField() {
        print("** focusOnNameField")
        objectWillChange.send()
        status.editingNameField = true
        status.editingPasswordField = false
        status.showEyeSymbol = false
        
        appearance.nameFieldWidth = Device.width * 0.8
        appearance.nameFieldScale = 1
        
        appearance.passwordFieldScale = 0.8
        appearance.passwordFieldOpacity = 0
    }
    
    private func focusOnPasswordField() {
        print("** focusOnPasswordField")
        objectWillChange.send()
        status.editingNameField = false
        status.editingPasswordField = true
        status.showEyeSymbol = true
        
        appearance.passwordFieldScale = 1
        appearance.passwordFieldOpacity = 1
        
        appearance.nameFieldWidth = 200
        appearance.nameFieldScale = 0.8
    }
    
    
    private func showError(_ errorMessage: ErrorMessage) {
//        print("** appstatus error",AppStatus.errorMessage)
        DispatchQueue.main.async {
            self.status.isErrorShown = true
            self.errorMessage = errorMessage
            self.status.authorisingUser = false
        }
    }
    
    
}


struct SignInViewAppearence {
    var activityIndicatorOpacity: Double = 0
    var fieldsOpacity: Double = 1
    var passwordFieldOpacity: Double = 0
    var nameFieldWidth: CGFloat = 200
    var passwordFieldWidth: CGFloat = Device.width * 0.8
    var nameFieldScale: CGFloat = 0.8
    var passwordFieldScale: CGFloat = 0.8
    var eyeSymbol: String = "eye.fill"
}

struct SignInViewStatus {
    var showPassword = false
    var authorisingUser = false
    var isErrorShown = false
    var editingNameField = false
    var editingPasswordField = false
    var showEyeSymbol = false
}
