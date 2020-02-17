//
//  SignUpView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/9.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    @State var editing = true
    var body: some View {
        NavigationView {
            VStack {
//                Form {
//                    Section(footer: Button(action: {
//                        self.viewModel.dismiss()
//                    }) {
//                        Text("注册")
//                            .fontWeight(.semibold)
//                            .font(.title)
//
//                    }.buttonStyle(GradientBackgroundStyle()).padding(.top, 20)) {
                    TextField("用户名", text: $viewModel.name)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 50, alignment: .center)
                    
                    HStack {
//                        CustomeTextField(text: $viewModel.password1, isEditing: $editing, showPassword: $viewModel.showPassword)
//                            .frame(height: 30)
                        Image(systemName: viewModel.eyeSymbol).onTapGesture {
                            self.viewModel.showPassword.toggle()
                        }.foregroundColor(.secondary)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 50, alignment: .center)
                        
//                    }

//                }
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text("欢迎注册"), trailing: Button(action: {
//                    self.viewModel.dismiss()
                }) {
                    HStack {
                        Text(" ")
                        Image(systemName: "xmark")
                            .font(.system(size: 14))
                        Text(" ")
                    }
                    .padding(3)
                    .foregroundColor(.white)
                    .background(Color(UIColor.opaqueSeparator))
                    .cornerRadius(13)
                }
            )
        }
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: .init(from: OnboardingViewModel()))
    }
}
