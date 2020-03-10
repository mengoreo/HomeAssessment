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


struct ProgressBar: View {
    @Binding var value:CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .opacity(0.1)
                    Rectangle()
                        .frame(minWidth: 0, idealWidth:self.getProgressBarWidth(geometry: geometry),
                               maxWidth: self.getProgressBarWidth(geometry: geometry))
//                        .opacity(0.5)
                        .background(Color.accentColor)
                        .animation(.myease)
                }
                .frame(height:5)
            }.frame(height:5)
        }
    }
    
    func getProgressBarWidth(geometry:GeometryProxy) -> CGFloat {
        let frame = geometry.frame(in: .global)
        return frame.size.width * value
    }
}


struct UIKitTabView: View {
    var viewControllers: [UIHostingController<AnyView>]
//    @State var selectedIndex: Int = 0
    @Binding var selectedIndex: Int16
    @Binding var hideTabBar: Bool
    init(_ views: [Tab],
         selectedIndex: Binding<Int16> = .constant(0),
         hideTabBar: Binding<Bool> = .constant(false)
    ) {
        self.viewControllers = views.map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
        self._selectedIndex = selectedIndex
        self._hideTabBar = hideTabBar
        print("UIKitTabView: ", hideTabBar.wrappedValue)
    }
    
    var body: some View {
        TabBarController(controllers: viewControllers, selectedIndex: $selectedIndex, hideTabBar: $hideTabBar)
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Tab {
        var view: AnyView
        var barItem: UITabBarItem
        
        init<V: View>(view: V, barItem: UITabBarItem) {
            self.view = AnyView(view)
            self.barItem = barItem
        }
        
        
        // convenience
        init<V: View>(view: V, title: String?, image: String, selectedImage: String? = nil) {
            let selectedImage = selectedImage != nil ? UIImage(systemName: image) : nil
            let barItem = UITabBarItem(title: title, image: UIImage(systemName: image), selectedImage: selectedImage)
            self.init(view: view, barItem: barItem)
        }
    }
}


