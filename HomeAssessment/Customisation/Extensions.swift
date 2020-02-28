//
//  Extensions.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/18.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreLocation

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
}

// MARK: - Foundation
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
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
    public static var darkGreen: UIColor {
        return UIColor(named: "DarkGreen") ?? UIColor.green
    }
    public static var lightGreen: UIColor {
        return UIColor(named: "LightGreen") ?? UIColor.green
    }
}

// MARK: - SwiftUI
extension Image {
    static var mapPreviewLight: Image {
        return Image("mapPreviewLight")
    }
    static var mapPreviewDark: Image {
        return Image("mapPreviewDark")
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
        return Image(systemName: "plus.circle.fill").imageScale(.large).accentColor(.lightGreen)
    }
    static var ellipsisCircleFill: some View {
        ZStack {
            Image(systemName: "circle.fill").imageScale(.large).foregroundColor(.init(UIColor.tertiarySystemFill))
            Image(systemName: "ellipsis").imageScale(.large).scaleEffect(0.6).foregroundColor(.lightGreen)
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
    public static var darkGreen: Color {
        return Color("DarkGreen")
    }
    public static var lightGreen: Color {
        return Color("LightGreen")
    }
}


