//
//  SignInUpViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import SwiftUI

enum ErrorType {
    case nameField
    case passwordField
}

struct ErrorMessage {
    var body: String
    var type: ErrorType
}
class SignInUpViewModel: ObservableObject {
    
    private var welcomViewModel: OnboardingViewModel!
    private var debugStringHeader = "** SignInViewModel:"
    
    @Published var name: String!
    @Published var password: String!
    @Published var showPassword: Bool!
    @Published var authorisingUser: Bool!
    @Published var errorMessage: ErrorMessage!
    @Published var isErrorShown: Bool!
    
    // set by other properties
    @Published var nameFieldScale: CGFloat!
    @Published var passwordFieldScale: CGFloat!
    
    private var displayed: Bool!
    
    var opacity: Double {
        if displayed {
            return 1
        } else {
            return 0
        }
    }
    
    var editingNameField: Bool! {
        willSet(newValue) {
            if newValue {
                nameFieldScale = 1
            } else {
                nameFieldScale = 0.8
            }
        }
    }
    var editingPasswordField: Bool! {
        willSet(newValue) {
            if newValue {
                passwordFieldScale = 1
                
            } else {
                passwordFieldScale = 0.8
            }
        }
    }
    var eyeSymbol: String {
        if showPassword {
            return "eye.slash.fill"
        }
        else {
            return "eye.fill"
        }
    }
    
    
    var tokenFetcher: TokenFetcher {
        return TokenFetcher(name: name, password: password)
    }
    
    init (from viewModel: OnboardingViewModel) {
        welcomViewModel = viewModel
        resetValues()
    }
    
    // MARK: - States
    func editing() -> Bool {
        return editingNameField || editingPasswordField
    }
    
    func disappeared() {
        print(debugStringHeader, "disappeared")
        if authorisingUser {
            // disappeared while authorising
            print(debugStringHeader, "already authorisingUser")
        }
        resetValues()
    }
    
    // MARK: - Actions
    
    func readyForDisplaying() {
        print(debugStringHeader, "readyForDisplaying")
        name = ""
        password = ""
        displayed = true
//        editNameField()
    }
    
    // while editing
    func editNameField() {
        print("*** editNameField")
        DispatchQueue.main.async {
            self.editingNameField = true
            self.editingPasswordField = false
            
        }
    }
    
    func editPasswordField() {
        DispatchQueue.main.async {
            self.editingPasswordField = true
            self.editingNameField = false
        }
    }
    
    func tappedOutsideField() {
        if editing() {
            print("*** reset")
            editingNameField = false
            editingPasswordField = false
        }
    }
    
    func showError(message: String, type: ErrorType) {
        DispatchQueue.main.async {
            self.isErrorShown = true
            self.errorMessage = ErrorMessage(body: message, type: type)
            self.authorisingUser = false
        }
    }
    
    func handleError() {
        DispatchQueue.main.async {
            self.welcomViewModel.readyForErrors()
        }
        switch errorMessage.type {
        case .nameField:
            editNameField()
            break
        case .passwordField:
            editPasswordField()
            break
        }
    }
    
    // done editing
    func dismiss() {
        print(self.debugStringHeader, "dismiss")
        self.editingNameField = false
        self.editingPasswordField = false
        self.welcomViewModel.showWelcom()
        
    }
    
    func authorising(_ forced: Bool? = nil) {
        self.editingNameField = false
        self.editingPasswordField = false
        self.authorisingUser = true
        
        if forced != nil {
            DispatchQueue.main.async {
                self.welcomViewModel.readyForAuthorising()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.authorised()
            }
            return
        }
        
        if name.count == 0 {
            self.showError(message: "用户名不能为空", type: .nameField)
            return
        }
        if password.count == 0 {
            self.showError(message: "密码不能为空", type: .passwordField)
            return
        }
        
        DispatchQueue.main.async {
            self.welcomViewModel.readyForAuthorising()
        }
        _ = tokenFetcher.fetchToken(completionHandler: checkTokenResponse(_:_:))
    }
    
    func authorised() {
        // make sure this will execute while authorising
        DispatchQueue.main.async {
            if self.authorisingUser {
                
                self.welcomViewModel.authorised = true                
                self.dismiss()
            }
            else {
                print(self.debugStringHeader, "already on it")
            }
        }
    }
    
    // MARK: - Helper
    func checkTokenResponse(_ token: String, _ error: NSError?) {
        if error != nil {
            self.showError(message: error!.cnDescription(), type: .passwordField)
        }
        else {
            self.authorised()
        }
    }
    
    func resetValues() {
        name = ""
        password = ""
        showPassword = false
        authorisingUser = false
//        errorMessage = ""
        isErrorShown = false
        displayed = false
        
        editingPasswordField = false
        editingNameField = false
        
        
    }
    
}
