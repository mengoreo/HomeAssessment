//
//  UIElements.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
//import UIKit
extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct SelectableRow<Label>: View where Label: View {
    
    private var action: () -> Void
    private let label: () -> Label
    private var selected: Bool
    
    public init(selected: Bool = false, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.selected = selected
        self.action = action
        self.label = label
    }
    
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                label()
                Spacer()
                Image(systemName: "checkmark")
                    .opacity(selected ? 1 : 0)
                    .foregroundColor(.lightGreen)
            }
        }
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
struct AttributedText: UIViewRepresentable {

    private var attributedString: NSAttributedString
    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    func makeUIView(context: Context) -> UILabel {
        let view = UILabel(frame: .zero)
        return view
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedString
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
extension UIColor {
    public static var darkGreen: UIColor {
        return UIColor(named: "DarkGreen") ?? UIColor.green
    }
    public static var lightGreen: UIColor {
        return UIColor(named: "LightGreen") ?? UIColor.green
    }
}
extension Image {
    public static var mapPreviewLight: Image {
        return Image("mapPreviewLight")
    }
    public static var mapPreviewDark: Image {
        return Image("mapPreviewDark")
    }
    public static var icon: Image {
        return Image("icon")
    }
}
extension View {
    public func roundedBorder(_ color: Color, width: CGFloat = 3, cornerRadius: CGFloat = 40) -> some View {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(color, lineWidth: width))
    }
    public func gradientBorder(_ colors: [Color], width: CGFloat = 3, cornerRadius: CGFloat = 40) -> some View {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing), lineWidth: width))
    }
}

class CustomSearchBar: UISearchBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: true)
    }
}


struct SearchBar : UIViewRepresentable {
    
    
    @Binding var text : String
//    @State var typping = true
    
    class Cordinator : NSObject, UISearchBarDelegate {
        
        @Binding var text : String
        
        init(text : Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.backgroundColor = .clear
//        searchBar.barStyle = .black
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .search
        searchBar.setValue("取消", forKey: "cancelButtonText")
        searchBar.isTranslucent = true
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
//        uiView.showsCancelButton = typping
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    final class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar
        
        init (_ parent: SearchBar) {
            self.parent = parent
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
            print("*** searchBarCancelButtonClicked")
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("*** searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)")
            parent.text = searchText
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            print("*** searchBarTextDidBeginEditin")
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        
    }
}


struct CollapsableGradientBackgroundStyle: ButtonStyle {
    
    var collapsed: Bool = false
    var xOffset: CGFloat = 0
    var yOffset: CGFloat = 0
    var colors: [Color] = [Color("DarkGreen"), Color("LightGreen")]
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: collapsed ? 30 : .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, collapsed ? 0 : 20)
            .offset(x: xOffset, y: yOffset)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct ImageButtonStyle: ButtonStyle {
    var width: CGFloat = Device.height / 7
    var height: CGFloat = Device.height / 7
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height, alignment: .center)
            .shadow(radius: configuration.isPressed ? 0 : 3.0)
            .padding(3)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct CollapsableOutlineBackgroundStyle: ButtonStyle {
    var collapsed: Bool = false
    var xOffset: CGFloat = 0
    var yOffset: CGFloat = 0
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: collapsed ? 30 : .infinity)
            .padding()
            .foregroundColor(Color("LightGreen"))
            .cornerRadius(40)
            .padding(.horizontal, collapsed ? 0 : 20)
            
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color("LightGreen"),lineWidth: 3)
                    .padding(.horizontal, collapsed ? 0 : 20)
            )
            .offset(x: xOffset, y: yOffset)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}


struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


struct CustomTextField: UIViewRepresentable {

    private var placeholder: String
    @Binding private var text: String
    private var isEditing: (Binding<Bool>)?
    private var showPassword: (Binding<Bool>)?

    private var didBeginEditing: () -> Void = { }
    private var didChange: () -> Void = { }
    private var didEndEditing: () -> Void = { }

    private var autocorrection: UITextAutocorrectionType = .default
    private var autocapitalization: UITextAutocapitalizationType = .sentences
    private var keyboardType: UIKeyboardType = .default
    private var returnKeyType: UIReturnKeyType = .default
    
    private var isUserInteractionEnabled: Bool = true
    private var showClearButton: Bool
    private var disabled: Bool
    private var tintColor: UIColor
    private var textColor: UIColor


    init(_ placeholder: String = "",
         text: Binding<String>,
         isEditing: (Binding<Bool>)? = nil,
         showPassword: (Binding<Bool>)? = nil,
         showClearButton: Bool = false,
         disabled: Bool = false,
         tintColor: UIColor = .lightGreen,
         textColor: UIColor = .darkGreen,
         didBeginEditing: @escaping () -> Void = { },
         didChange: @escaping () -> Void = { },
         didEndEditing: @escaping () -> Void = { })
    {
        self.placeholder = placeholder
        self._text = text
        self.isEditing = isEditing
        self.showClearButton = showClearButton
        self.disabled = disabled
        self.didBeginEditing = didBeginEditing
        self.didChange = didChange
        self.didEndEditing = didEndEditing
        self.showPassword = showPassword
        self.tintColor = tintColor
        self.textColor = textColor
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()

        textField.delegate = context.coordinator
        
        textField.autocorrectionType = autocorrection
        textField.autocapitalizationType = autocapitalization
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        textField.placeholder = placeholder
        
        textField.clearButtonMode = showClearButton ? .whileEditing : .never
        if let showPassword = showPassword?.wrappedValue {
            textField.isSecureTextEntry = !showPassword
        }
        textField.isUserInteractionEnabled = isUserInteractionEnabled
        
        textField.tintColor = tintColor
        textField.textColor = textColor

         // in case too long/high to overflow the view
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)


        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)

        
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.textColor = textColor
        if let showPassword = showPassword?.wrappedValue {
            uiView.isSecureTextEntry = !showPassword
        }
        if uiView.window != nil, let isEditing = isEditing  {
            if isEditing.wrappedValue {
                print("**** already \(uiView.isFirstResponder)")
                uiView.becomeFirstResponder()
            }
        }
        
        uiView.isEnabled = !disabled
        if disabled {
            uiView.resignFirstResponder()
            uiView.textColor = .tertiaryLabel
        }
    }

    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        var didBecomeFirstResponder = false

        init(_ textField: CustomTextField) {
            self.parent = textField
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                if let isEditing = self.parent.isEditing,
                    !isEditing.wrappedValue {
                    self.parent.isEditing?.wrappedValue = true
                }
                self.parent.didBeginEditing()
            }
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            self.parent.text = textField.text ?? ""
            self.parent.didChange()
        }

        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            DispatchQueue.main.async {
                self.parent.isEditing?.wrappedValue = false
                
                self.parent.didEndEditing()
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if parent.showPassword != nil {
                parent.showPassword?.wrappedValue = false
            }
            parent.isEditing?.wrappedValue = false
            return true
        }
    }

}

