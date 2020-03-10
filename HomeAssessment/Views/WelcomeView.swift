//
//  WelcomeView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/9.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: WelcomeViewModel
    var body: some View {
        ZStack {
            if viewModel.signedIn {
                ZStack {
                    TabsContainer(selected: $viewModel.selectedTab, hide: $viewModel.hide)
                        .animation(.none)
                }
                .opacity(viewModel.uiProperties.mainViewOpacity) // delay show
                .animation(.myease)
            } else {
                ZStack {
                    Color(UIColor.systemBackground)
                    ICON()
                    if viewModel.needToSignIn {
                        SignInUpView(viewModel: .init())
                            .opacity(1)
                            .animation(.myease)
                    }
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
    }
}

extension WelcomeView {
//    func BUTTONS() -> some View {
//        return VStack {
//            Spacer()
//            HStack {
//                if viewModel.signInUpViewModal {
//                    Button(action: {
//                        self.viewModel.showWelcom()
//                        self.viewModel.updateView()
//                    }) {
//                        Image(systemName: "chevron.left").font(.title).frame(height: 30)
//
//                    }.padding(.leading, 20)
//                    .buttonStyle(CollapsableOutlineBackgroundStyle(collapsed: true))
//                }
//
//                Button(action: {
////                    self.viewModel.showSignInView()
//                    if self.viewModel.signInUpViewModal {
//                        self.signInUpView.viewModel.authorising()
//                    } else {
//                        self.viewModel.showSignInUpView()
//
//                    }
//                    self.viewModel.updateView()
//                }) {
//                    Text("登录/注册")
//                        .fontWeight(.semibold)
//                        .font(.title)
//                }
//                .buttonStyle(CollapsableGradientBackgroundStyle())
//
//            }
//        }
//        .padding(.bottom, viewModel.uiProperties.buttonBottomPadding)
//        .animation(.myease)
//    }
    
    func ICON() -> some View {
                    
        Image("icon")
            .resizable()
            .frame(
                width: viewModel.uiProperties.iconFrame.width,
                height: viewModel.uiProperties.iconFrame.height, alignment: .center)
            .padding(.top, viewModel.uiProperties.iconTopPadding)
            .padding(.bottom, viewModel.uiProperties.iconBottomPadding)
            .padding(.trailing, viewModel.uiProperties.iconTrailingPadding)
            .opacity(viewModel.uiProperties.iconOpacity)
            .scaleEffect(CGFloat(viewModel.uiProperties.iconScale))
            .animation(.myease)           
            
        }

}



#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE"], id: \.self) { deviceName in
            WelcomeView(viewModel: .init())
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif

