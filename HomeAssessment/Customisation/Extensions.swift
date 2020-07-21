//
//  Extensions.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/18.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreLocation
import ARKit

// MARK: - CoreLocation
extension CLPlacemark {
    func address() -> String {
        var line1 = self.administrativeArea ?? ""

        line1 += self.subAdministrativeArea ?? ""
        line1 += self.locality ?? ""
        line1 += self.subLocality ?? ""
        line1 += self.thoroughfare == nil ? "" : "\n" + self.thoroughfare!
        line1 += self.subThoroughfare ?? ""
        return line1.isEmpty ? "无详细信息" : line1
    }
    func isEqualTo(_ another: CLPlacemark) -> Bool {
        if (self.location == nil) != (another.location == nil) {
            // one of them not valid
            return false
        }
        if let a = self.location, let b = another.location {
            // both valid
            return a.distance(from: b) < 10
        }
        return true // both not valide
    }
}
// MARK: - ARKit
extension ARSCNView {
    func hitResult(forPoint point: CGPoint) -> SCNVector3? {
        let hitTestResults = hitTest(point, types: .featurePoint)
        if let result = hitTestResults.first {
            let vector = result.worldTransform.columns.3
            return SCNVector3(vector.x, vector.y, vector.z)
        } else {
            return nil
        }
    }
    func distance(betweenPoints point1: SCNVector3, point2: SCNVector3) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        let dz = point2.z - point1.z
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }
}
// MARK: - Foundation
extension Notification.Name {
    static let WillEditAssessment = NSNotification.Name("WillEditAssessment")
    static let WillShareAssessment = NSNotification.Name("WillShareAssessment")
    static let WillCombineAssessments = NSNotification.Name("WillCombineAssessments")
    static let DoneCombineAssessments = NSNotification.Name("DoneCombineAssessments")
    static let QuestionReadyToSave = NSNotification.Name("QuestionReadyToSave")
    static let QuestionUnableToSave = NSNotification.Name("QuestionUnableToSave")
    static let SceneDidEnterBackground = NSNotification.Name("SceneDidEnterBackground")
}
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var intValue: Int32 {
        return (self as NSString).intValue
    }
}
extension Date {
    var relevantString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        if dateFormatter.string(from: Date()) != dateFormatter.string(from: self) {
            dateFormatter.dateFormat = "HH:mm yyyy-MM-dd"
        } else {
            dateFormatter.dateFormat = "HH:mm MM-dd"
        }
        return dateFormatter.string(from: self)
    }
    static var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}

// MARK: - UIKit
extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
extension UIImage {
    static var mapPreview: UIImage {
        return UIImage(named: "mapPreview") ?? UIImage()
    }
    static var placemark: UIImage {
        return UIImage(named: "placemark") ?? UIImage()
    }
}
extension UIView {
    func show() {
        Self.animate(withDuration: 0.3) {
            self.layer.opacity = 1
        }
    }
    func hide() {
        Self.animate(withDuration: 0.3) {
            self.layer.opacity = 0
        }
    }
}
extension UITextField{

    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Device.width, height: 40))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        done.tintColor = .lightGreen

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }
}
extension UIColor {
    public static var tintColor: UIColor {
        return UIColor(named: "myAccentColor") ?? UIColor.green
    }
    public static var darkGreen: UIColor {
        return UIColor(named: "DarkGreen") ?? UIColor.green
    }
    public static var lightGreen: UIColor {
        return UIColor(named: "LightGreen") ?? UIColor.green
    }
}
enum Model : String {
    case simulator   = "simulator/sandbox",
    iPod1            = "iPod 1",
    iPod2            = "iPod 2",
    iPod3            = "iPod 3",
    iPod4            = "iPod 4",
    iPod5            = "iPod 5",
    iPad2            = "iPad 2",
    iPad3            = "iPad 3",
    iPad4            = "iPad 4",
    iPhone4          = "iPhone 4",
    iPhone4S         = "iPhone 4S",
    iPhone5          = "iPhone 5",
    iPhone5S         = "iPhone 5S",
    iPhone5C         = "iPhone 5C",
    iPadMini1        = "iPad Mini 1",
    iPadMini2        = "iPad Mini 2",
    iPadMini3        = "iPad Mini 3",
    iPadAir1         = "iPad Air 1",
    iPadAir2         = "iPad Air 2",
    iPadPro9_7       = "iPad Pro 9.7\"",
    iPadPro9_7_cell  = "iPad Pro 9.7\" cellular",
    iPadPro10_5      = "iPad Pro 10.5\"",
    iPadPro10_5_cell = "iPad Pro 10.5\" cellular",
    iPadPro12_9      = "iPad Pro 12.9\"",
    iPadPro12_9_cell = "iPad Pro 12.9\" cellular",
    iPhone6          = "iPhone 6",
    iPhone6plus      = "iPhone 6 Plus",
    iPhone6S         = "iPhone 6S",
    iPhone6Splus     = "iPhone 6S Plus",
    iPhoneSE         = "iPhone SE",
    iPhone7          = "iPhone 7",
    iPhone7plus      = "iPhone 7 Plus",
    iPhone8          = "iPhone 8",
    iPhone8plus      = "iPhone 8 Plus",
    iPhoneX          = "iPhone X",
    iPhoneXS         = "iPhone XS",
    iPhoneXSmax      = "iPhone XS Max",
    iPhoneXR         = "iPhone XR",
    iPhone11         = "iPhone 11",
    iPhone11Pro      = "iPhone 11 Pro",
    iPhone11ProMax   = "iPhone 11 Pro Max",
    unrecognized     = "?unrecognized?"
}

extension UIDevice {
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)

            }
        }
        let modelMap : [ String : Model ] = [
            "i386"       : .simulator,
            "x86_64"     : .simulator,
            "iPod1,1"    : .iPod1,
            "iPod2,1"    : .iPod2,
            "iPod3,1"    : .iPod3,
            "iPod4,1"    : .iPod4,
            "iPod5,1"    : .iPod5,
            "iPad2,1"    : .iPad2,
            "iPad2,2"    : .iPad2,
            "iPad2,3"    : .iPad2,
            "iPad2,4"    : .iPad2,
            "iPad2,5"    : .iPadMini1,
            "iPad2,6"    : .iPadMini1,
            "iPad2,7"    : .iPadMini1,
            "iPhone3,1"  : .iPhone4,
            "iPhone3,2"  : .iPhone4,
            "iPhone3,3"  : .iPhone4,
            "iPhone4,1"  : .iPhone4S,
            "iPhone5,1"  : .iPhone5,
            "iPhone5,2"  : .iPhone5,
            "iPhone5,3"  : .iPhone5C,
            "iPhone5,4"  : .iPhone5C,
            "iPad3,1"    : .iPad3,
            "iPad3,2"    : .iPad3,
            "iPad3,3"    : .iPad3,
            "iPad3,4"    : .iPad4,
            "iPad3,5"    : .iPad4,
            "iPad3,6"    : .iPad4,
            "iPhone6,1"  : .iPhone5S,
            "iPhone6,2"  : .iPhone5S,
            "iPad4,1"    : .iPadAir1,
            "iPad4,2"    : .iPadAir2,
            "iPad4,4"    : .iPadMini2,
            "iPad4,5"    : .iPadMini2,
            "iPad4,6"    : .iPadMini2,
            "iPad4,7"    : .iPadMini3,
            "iPad4,8"    : .iPadMini3,
            "iPad4,9"    : .iPadMini3,
            "iPad6,3"    : .iPadPro9_7,
            "iPad6,11"   : .iPadPro9_7,
            "iPad6,4"    : .iPadPro9_7_cell,
            "iPad6,12"   : .iPadPro9_7_cell,
            "iPad6,7"    : .iPadPro12_9,
            "iPad6,8"    : .iPadPro12_9_cell,
            "iPad7,3"    : .iPadPro10_5,
            "iPad7,4"    : .iPadPro10_5_cell,
            "iPhone7,1"  : .iPhone6plus,
            "iPhone7,2"  : .iPhone6,
            "iPhone8,1"  : .iPhone6S,
            "iPhone8,2"  : .iPhone6Splus,
            "iPhone8,4"  : .iPhoneSE,
            "iPhone9,1"  : .iPhone7,
            "iPhone9,2"  : .iPhone7plus,
            "iPhone9,3"  : .iPhone7,
            "iPhone9,4"  : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSmax,
            "iPhone11,6" : .iPhoneXSmax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax
        ]

    if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            return model
        }
        return Model.unrecognized
    }
}
// MARK: - SwiftUI
extension Image {
    static var mapPreview: Image {
        return Image("mapPreview")
    }
    static var icon: Image {
        return Image("icon")
    }
}

extension Animation {
    public static var myease: Animation {
        return Animation.timingCurve(0.68, -0.33, 0.265, 1.55, duration: 0.87)
    }
    public static func myease(duration: Double = 0.87, delay: Double = 0) -> Animation {
        return Animation.timingCurve(0.68, -0.33, 0.265, 1.55, duration: duration).delay(delay)
    }
}

extension View {
    static var plusCircleFill: some View {
        return Image(systemName: "plus.circle.fill").imageScale(.large).accentColor(.accentColor)
    }
    static var ellipsisCircleFill: some View {
        ZStack {
            Image(systemName: "circle.fill").imageScale(.large).foregroundColor(.init(UIColor.tertiarySystemFill))
            Image(systemName: "ellipsis").imageScale(.large).scaleEffect(0.6).foregroundColor(.accentColor)
        }
    }
    public func roundedBorder(_ color: Color, width: CGFloat = 3, cornerRadius: CGFloat = 40) -> some View {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(color, lineWidth: width))
    }
    public func gradientBorder(_ colors: [Color], width: CGFloat = 3, cornerRadius: CGFloat = 40) -> some View {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing), lineWidth: width))
    }
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
    func actionSheetTintColor(color: UIColor) -> some View {
        return modifier(ActionSheetTint(color: color))
    }
}

extension Color {
    public static var accentColor: Color {
        return Color("myAccentColor")
    }
    public static var darkGreen: Color {
        return Color("DarkGreen")
    }
    public static var lightGreen: Color {
        return Color("LightGreen")
    }
}


