//
//  States.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation

enum OnboardingState: Equatable {
    case welcoming
    case signingIn
    case signingUp
    case signedIn
    
    public static func == (lhs: OnboardingState, rhs: OnboardingState) -> Bool {
        switch (lhs, rhs) {
        case (.welcoming, .welcoming):
          return true
        case (.signingIn, .signingIn):
          return true
        case (.signingUp, .signingUp):
          return true
        case (.signedIn, .signedIn):
            return true
        case (.welcoming, _),
             (.signingIn, _),
             (.signedIn, _),
             (.signingUp, _):
          return false
        }
    }
    
    var description: String {
        switch self {
        case .welcoming:
            return "welcoming"
        case .signingIn:
            return "signingIn"
        case .signingUp:
            return "signingUp"
        case .signedIn:
        return "signedIn"
        }
    }
    
}

//enum AppRunningState: Equatable {
//  
//    case onboarding(OnboardingState)
//    case signedIn
////  case signedIn(SignedInViewControllerState, UserSession)
//}
//
//enum AppState {
//    case launching
//    case running(AppRunningState)
//    
//}

//class StateStore: ObservableObject {
//    @Published var appState: AppState
//
//    init(appState state: AppState) {
//        self.appState = state
//    }
//    
//    var currentState: String {
//        switch appState {
//        case .launching:
//            return "launching"
//        case .running(.onboarding(.signingIn)):
//            return "running.onboarding.signingIn"
//        case .running(.onboarding(.signingUp)):
//            return "running.onboarding.signingUp"
//        case .running(.onboarding(.welcoming)):
//            return "running.onboarding.welcoming"
//        case .running(.signedIn):
//            return "running.signedIn"
//        }
//    }
//    
//    func nextState() {
//        switch appState {
//        case .launching:
//            self.appState = .running(.onboarding(.signingIn))
//            break
//        case .running(.onboarding(.signingIn)):
//            self.appState = .running(.onboarding(.signingUp))
//            break
//        case .running(.onboarding(.signingUp)):
//            self.appState = .running(.onboarding(.welcoming))
//            break
//        case .running(.onboarding(.welcoming)):
//            self.appState = .running(.signedIn)
//            break
//        case .running(.signedIn):
//            self.appState = .launching
//            break
//        }
//    }
//    
//}
