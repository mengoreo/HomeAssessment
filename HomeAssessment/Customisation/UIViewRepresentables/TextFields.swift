//
//  TextFields.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

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
    private var keyboardType: UIKeyboardType
    private var returnKeyType: UIReturnKeyType
    
    private var isUserInteractionEnabled: Bool = true
    private var showClearButton: Bool
    private var disabled: Bool
    private var tintColor: UIColor
    private var textColor: UIColor


    init(_ placeholder: String = "",
         text: Binding<String>,
         isEditing: (Binding<Bool>)? = nil,
         showPassword: (Binding<Bool>)? = nil,
         showClearButton: Bool? = nil,
         disabled: Bool? = nil,
         tintColor: UIColor? = nil,
         textColor: UIColor? = nil,
         keyboardType: UIKeyboardType? = nil,
         returnKeyType: UIReturnKeyType? = nil,
         didBeginEditing: @escaping () -> Void = { },
         didChange: @escaping () -> Void = { },
         didEndEditing: @escaping () -> Void = { })
    {
        self.placeholder = placeholder
        self._text = text
        self.isEditing = isEditing
        self.showPassword = showPassword
        self.showClearButton = showClearButton ?? false
        self.disabled = disabled ?? false
        self.tintColor = tintColor ?? .lightGreen
        self.textColor = textColor ?? .label
        self.didBeginEditing = didBeginEditing
        self.keyboardType = keyboardType ?? .default
        self.returnKeyType = returnKeyType ?? .default
        self.didChange = didChange
        self.didEndEditing = didEndEditing
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()

        textField.delegate = context.coordinator
        
        textField.autocorrectionType = autocorrection
        textField.autocapitalizationType = autocapitalization
        textField.keyboardType = keyboardType
        if keyboardType == .phonePad {
            textField.addDoneButtonToKeyboard(myAction: #selector(textField.resignFirstResponder))
        }
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

        textField.text = text
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)

//        if let showPassword = showPassword?.wrappedValue {
//            textField.isSecureTextEntry = !showPassword
//        }
//        if textField.window != nil, let isEditing = isEditing  {
//            if isEditing.wrappedValue {
//                textField.becomeFirstResponder()
//            }
//        }
        
        
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
//        uiView.text = text
//        uiView.textColor = textColor
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
        
//
//        uiView.isEnabled = !disabled
//        if disabled {
//            uiView.resignFirstResponder()
//            uiView.textColor = .tertiaryLabel
//        }
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
            print("*** textFieldDidBeginEditing")
            DispatchQueue.main.async {
                if let isEditing = self.parent.isEditing,
                    !isEditing.wrappedValue {
                    self.parent.isEditing?.wrappedValue = true
                }
                self.parent.didBeginEditing()
            }
        }
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            print("*** textFieldShouldEndEditing")
            self.parent.isEditing?.wrappedValue = false
            return true
        }
        @objc func textFieldDidChange(_ textField: UITextField) {
            self.parent.text = textField.text ?? ""
            self.parent.didChange()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("*** textFieldShouldReturn")
            textField.resignFirstResponder()
            if parent.showPassword != nil {
                parent.showPassword?.wrappedValue = false
            }
            parent.isEditing?.wrappedValue = false
            self.parent.didEndEditing()
            return true
        }
    }

}
