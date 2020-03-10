//
//  SignInUpView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/9.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct SignInUpView: View {
    @ObservedObject var viewModel: SignInViewModel
    
    
    var body: some View {
        
        ZStack {
            ActivityIndicator(isAnimating: $viewModel.status.authorisingUser, style: .large)
                .foregroundColor(.red)
                .opacity(viewModel.appearance.activityIndicatorOpacity)
            
            ZStack {
                PasswordView().alignmentGuide(VerticalAlignment.center, computeValue: viewModel.passwordV(_:))
                    .opacity(viewModel.appearance.passwordFieldOpacity)
                    .animation(.myease)
                NameView().alignmentGuide(VerticalAlignment.center, computeValue: viewModel.nameV(_:))
                    .alert(isPresented: $viewModel.status.isErrorShown) {
                        Alert(title: Text(viewModel.errorMessage!.body), dismissButton: .default(Text("知道了"), action: {
                            self.viewModel.handleError()
                        }))
                    }
            }   
            .opacity(viewModel.appearance.fieldsOpacity)
            
        }
        .onAppear(perform: viewModel.onAppear)
    }
}

extension SignInUpView {
    func NameView() -> some View {
        return HStack {
            Image(systemName: "person")
                .foregroundColor(.secondary)
            
            CustomTextField("用户名", text: $viewModel.name,
                            isEditing: $viewModel.status.editingNameField,
                            didBeginEditing: viewModel.willEditNameField,
                            didEndEditing:self.viewModel.willEndEditingNameField)
                .truncationMode(.middle).frame(height: 30)
        }
        .padding()
        .gradientBorder([.red, .yellow], cornerRadius: 30)
        .frame(width: viewModel.appearance.nameFieldWidth)
        .scaleEffect(viewModel.appearance.nameFieldScale)
        .padding(.bottom, 10)
    }
    func PasswordView() -> some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.secondary)
            
            CustomTextField("密码", text: $viewModel.password,
                            isEditing: $viewModel.status.editingPasswordField,
                            showPassword: $viewModel.status.showPassword,
                            didEndEditing: viewModel.willEndEditingPasswordField)
                .truncationMode(.middle)
                .frame(height: 30)
            if viewModel.status.showEyeSymbol {
                Button(action: viewModel.toggleShowPassword) {
                        Image(systemName: self.viewModel.appearance.eyeSymbol)
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .gradientBorder([.green, .blue], cornerRadius: 30)
        .frame(width: viewModel.appearance.passwordFieldWidth)
        .scaleEffect(viewModel.appearance.passwordFieldScale)
        .padding(.bottom, 10)
    }
    
    
    
}
