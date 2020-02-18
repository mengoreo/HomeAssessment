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
        
        VStack {
            ActivityIndicator(isAnimating: $viewModel.authorisingUser, style: .large)
                .foregroundColor(.red)
                .opacity(viewModel.authorisingUser ? 1 : 0)
            ZStack {
                NameView().alignmentGuide(VerticalAlignment.center, computeValue:nameV(_:))
                
                PasswordView().alignmentGuide(VerticalAlignment.center, computeValue:passwordV(_:))
            }
            .padding()
            .opacity(viewModel.authorisingUser ? 0 : 1)
            
        }
        .opacity(viewModel.opacity).animation(.myease)
        .onAppear {
            self.viewModel.readyForDisplaying()
        }.onDisappear {
            self.viewModel.disappeared()
        }
    }
}

extension SignInUpView {
    func NameView() -> some View {
        return HStack {
            Image(systemName: "person")
                .foregroundColor(.secondary)
            
            CustomTextField(text: $viewModel.name, isEditing: $viewModel.editingNameField, didEndEditing: {self.viewModel.editPasswordField()}).truncationMode(.middle).frame(height: 30)
        }
        .padding()
        .gradientBorder([.red, .yellow], cornerRadius: 30)
        .frame(width: Device.width * 0.8)
        .scaleEffect(viewModel.nameFieldScale)
        .padding(.bottom, 10)
    }
    func PasswordView() -> some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.secondary)
            
            CustomTextField(text: $viewModel.password, isEditing: $viewModel.editingPasswordField, showPassword: $viewModel.showPassword)
                .truncationMode(.middle)
                .frame(height: 30)
            if viewModel.editingPasswordField {
                Button(action: { print("touched")
                    self.viewModel.showPassword.toggle()}) {

                    Image(systemName: self.viewModel.eyeSymbol)
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .gradientBorder([.green, .blue], cornerRadius: 30)
        .frame(width: Device.width * 0.8)
            .scaleEffect(viewModel.passwordFieldScale)
            .padding(.bottom, 10)
    }
    

    func nameV(_ d: ViewDimensions) -> CGFloat {
        if !viewModel.editing() {
            return 0
        } else if viewModel.editingNameField {
            return d[.bottom] + 10
        } else { // editingPasswordField
            return d[.top] - 10
        }
    }


    func passwordV(_ d: ViewDimensions) -> CGFloat {
        if !viewModel.editing() {
            return 0
        } else if viewModel.editingNameField {
            return d[.top] - 10
        } else { // editingPasswordField
            return d[.bottom] + 10
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(["iPhone 11 Pro", "iPhone SE"], id: \.self) { deviceName in
            SignInUpView(viewModel: .init(from: OnboardingViewModel()))
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
        
    }
}
