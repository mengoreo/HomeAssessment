//
//  CustomViews.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
//import UIKit


struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
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

struct ActionSheetConfigurator: UIViewControllerRepresentable {
    var configure: (UIAlertController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActionSheetConfigurator>) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<ActionSheetConfigurator>) {
        if let actionSheet = uiViewController.presentedViewController as? UIAlertController,
        actionSheet.preferredStyle == .actionSheet {
            self.configure(actionSheet)
        }
    }
}

struct ActionSheetTint: ViewModifier {
    var color: UIColor
    func body(content: Content) -> some View {
        content
            .background(ActionSheetConfigurator { action in
                // change the text color
                action.view.tintColor = self.color
            })
    }
}



