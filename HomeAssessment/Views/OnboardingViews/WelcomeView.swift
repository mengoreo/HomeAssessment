//
//  WelcomeView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/9.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI


struct WelcomeView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    @State private var iconOffset: CGFloat = -100
    @State private var buttonOffset: CGFloat = -100
    private var signInView: SignInView
//    private var signUpView: SignUpView
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        self.signInView = SignInView(viewModel: .init(from: viewModel))
    }
    
    var body: some View {
        ZStack {
            VStack {
                ICON()
                if viewModel.signInViewModal {
                    signInView
                }
//                signInView.frame(width: 0, height: 0, alignment: .center)
                BUTTONS()
            }
            AssessmentListView()
                .opacity(self.viewModel.displayHome ? 0 : 0)
                .animation(.linear)
        }
    }
}

extension WelcomeView {
    func BUTTONS() -> some View {
        return VStack {
            if !self.viewModel.displayHome {
                Spacer()
            }
            HStack {
                Button(action: {
                    
                    if self.viewModel.signInViewModal {
                        self.viewModel.showWelcom()
                    } else {
                        self.viewModel.showSignUpView()
                    }
                    self.viewModel.updateIcon()
                }) {
                    HStack {
                        if self.viewModel.signInViewModal {
                            Image(systemName: "chevron.right").font(.title).frame(height: 30)
                        } else {
                            Text("注册")
                                .fontWeight(.semibold)
                                .font(.title)
                        }
                    }
                                        
                }.buttonStyle(CollapsableOutlineBackgroundStyle(collapsed: viewModel.signInViewModal, xOffset: viewModel.signInViewModal ? 20 : 0))
                
                Button(action: {
//                    self.viewModel.showSignInView()
                    if self.viewModel.signInViewModal {
                        self.signInView.viewModel.authorising()
                        self.viewModel.updateIcon()
                    } else {
                        self.viewModel.showSignInView()
                        self.viewModel.updateIcon()
                    }
                }) {
                    Text("登录")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .buttonStyle(CollapsableGradientBackgroundStyle())
                
            }
        }
        .padding(.bottom, buttonOffset).animation(.myease)
        .onAppear{
            self.buttonOffset = 23
        }
    }
    
    func ICON() -> some View {
                    
        Image("icon")
            .resizable()
            .frame(
                width: viewModel.iconProperties.frame.width,
                height: viewModel.iconProperties.frame.height, alignment: .center)
            .padding(.top, viewModel.iconProperties.topPadding)
            .padding(.bottom, viewModel.iconProperties.bottomPadding)
            .opacity(viewModel.iconProperties.opacity)
            .animation(.myease)
            .onAppear{
                self.viewModel.updateIcon()
            }
            
        }

}



#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 11 Pro", "iPhone SE"], id: \.self) { deviceName in
            WelcomeView(viewModel: .init())
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif

