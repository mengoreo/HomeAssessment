//
//  Models.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/18.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreLocation

// MARK: - Application
struct Device {
    public static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    public static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    public static var rotation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
}

// MARK: - Assessment related
struct ALUIProperties {
    var imgWidth: CGFloat
    var imgXOffset: CGFloat
    var imgYOffset: CGFloat
}




struct UIProperties {
    var iconTopPadding: CGFloat = 0
    var iconBottomPadding: CGFloat = 0
    var iconTrailingPadding: CGFloat = 0
    var iconOpacity: Double = 1
    var iconScale: Double = 1
    var iconFrame = CGSize(width: Device.width / 2, height: Device.width / 2)
//    var buttonBottomPadding: CGFloat = 0
    var mainViewOpacity: Double = 1
}

// MARK: - Sign In/Up
enum SignInErrorType: Error {
    case nameField
    case passwordField
}

struct ErrorMessage {
    var body: String
    var type: ErrorType
}

enum ErrorType: Error {
    case signInError(SignInErrorType)
    case uploadError
    case serverError
}
