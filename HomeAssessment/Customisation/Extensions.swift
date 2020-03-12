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
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        if dateFormatter.string(from: Date()) != dateFormatter.string(from: self) {
            dateFormatter.dateFormat = "HH:mm yyyy-MM-dd"
        } else {
            dateFormatter.dateFormat = "HH:mm MM-dd"
        }
        return dateFormatter.string(from: self)
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


