//
//  SignUpViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation

class SignUpViewModel: ObservableObject {
    
    private var welcomViewModel: OnboardingViewModel!
    private var debugStringHeader = "** SignUpViewModel:"
    @Published var name: String!
    @Published var password1: String!
    @Published var password2: String!
    @Published var showPassword: Bool!
    @Published var authorisingUser: Bool!
    @Published var errorMessage: String!
    @Published var isErrorShown: Bool!
    
    var eyeSymbol: String {
        if showPassword {
            return "eye.slash.fill"
        }
        else {
            return "eye.fill"
        }
    }
    
    var tokenFetcher: TokenFetcher {
        return TokenFetcher(name: name, password: password2)
    }
    
    init (from viewModel: OnboardingViewModel) {
        welcomViewModel = viewModel
        readyForDisplaying()
    }
    
    func readyForDisplaying() {
        print(debugStringHeader, "readyForDisplaying")
        name = "a" + String(DispatchTime.now().rawValue)
        password1 = "a"
        password2 = "a"
        showPassword = false
        authorisingUser = false
        errorMessage = ""
        isErrorShown = false
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.isErrorShown = true
            self.errorMessage = message
            self.authorisingUser = false
        }
    }
    func dismiss() {
        DispatchQueue.main.async {
            print(self.debugStringHeader, "dismiss")
            self.welcomViewModel.showWelcom()
        }
    }
    
    func authorising() {
        self.authorisingUser = true
        if name.count == 0 {
            self.showError(message: "用户名不能为空")
            return
        }
        if password1 != password2 {
            self.showError(message: "两次密码不一致")
            return
        }
        if password1.count == 0 {
            self.showError(message: "密码不能为空")
            return
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
    
    func checkTokenResponse(_ token: String, _ error: NSError?) {
        if error != nil {
            self.showError(message: error!.cnDescription())
        }
        else {
            self.authorised()
        }
    }
}

