//
//  Extensions.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/18.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

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

extension View {
    static var plusCircleFill: some View {
        ZStack {
            Image(systemName: "circle.fill").foregroundColor(.lightGreen)
            Image(systemName: "plus").scaleEffect(0.6).foregroundColor(.init(UIColor.white))
        }
    }
    static var ellipsisCircleFill: some View {
        ZStack {
            Image(systemName: "circle.fill").foregroundColor(.init(UIColor.tertiarySystemFill))
            Image(systemName: "ellipsis").scaleEffect(0.6).foregroundColor(.lightGreen)
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
}

extension Color {
    public static var darkGreen: Color {
        return Color("DarkGreen")
    }
    public static var lightGreen: Color {
        return Color("LightGreen")
    }
}


