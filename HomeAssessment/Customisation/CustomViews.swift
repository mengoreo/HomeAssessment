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


struct SearchBar : UIViewRepresentable {
    
    
    @Binding var text : String
    @Binding var searching: Bool
    
    
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
            parent.searching = false
            print("*** searchBarCancelButtonClicked")
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("*** searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)")
            parent.text = searchText
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            print("*** searchBarTextDidBeginEditin")
            parent.searching = true
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        
        
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
         showClearButton: Bool = false,
         disabled: Bool = false,
         tintColor: UIColor = .lightGreen,
         textColor: UIColor = .label,
         keyboardType: UIKeyboardType = .default,
         returnKeyType: UIReturnKeyType = .default,
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
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
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
            self.parent.isEditing?.wrappedValue = false
            return true
        }
        @objc func textFieldDidChange(_ textField: UITextField) {
            self.parent.text = textField.text ?? ""
            self.parent.didChange()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

struct SearchResultView<Content: View>: View {
    @Binding var searchText: String
    private var content: (_ searchText:String)->Content
    init(result searchText: Binding<String>, @ViewBuilder content: @escaping (_ searchText:String) -> Content) {
        self._searchText = searchText
        self.content = content
    }
    var body: some View {
        content(searchText)
    }
}

struct SearchModalView<Result: View>: UIViewControllerRepresentable {
    @Binding var searchText: String
    private var content: (_ searchText:String) -> Result
    private var searchBarPlaceholder: String
    
    private var barTitle: String
    private var preferLargeTitle: Bool
    private var searchScope: [String]?
    
    init(_ searchBarPlaceholder: String = "",
         searchedText: Binding<String>,
         barTitle: String = "Search",
         preferLargeTitle: Bool = false,
         scopes: [String]? = nil,
         @ViewBuilder resultView: @escaping (_ searchText:String) -> Result){
        self.searchBarPlaceholder = searchBarPlaceholder
        self.content = resultView
        self._searchText = searchedText
        // optional
        self.barTitle = barTitle
        self.preferLargeTitle = preferLargeTitle
        self.searchScope = scopes
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let contentViewController = UIHostingController(rootView: SearchResultView(result: $searchText, content: content))
        contentViewController.view.frame.size.height = 0
        let navigationController = UINavigationController(rootViewController: contentViewController)
        navigationController.navigationBar.prefersLargeTitles = preferLargeTitle
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = context.coordinator
        searchController.obscuresBackgroundDuringPresentation = false // for results
        searchController.searchBar.placeholder = searchBarPlaceholder
        searchController.searchBar.scopeButtonTitles = searchScope
        searchController.searchBar.setValue("取消", forKey: "cancelButtonText")
        
        contentViewController.navigationItem.title = barTitle
        contentViewController.navigationItem.searchController = searchController
        contentViewController.navigationItem.hidesSearchBarWhenScrolling = true
        contentViewController.definesPresentationContext = true
        
        searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<SearchModalView>) {}
}

extension SearchModalView {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
        var parent: SearchModalView
        init(_ parent: SearchModalView){self.parent = parent}
        
        // MARK: - UISearchResultsUpdating
        func updateSearchResults(for searchController: UISearchController) {
            self.parent.searchText = searchController.searchBar.text!
        }
        
        // MARK: - UISearchBarDelegate
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.parent.searchText = ""
        }

        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            self.parent.searchText = ""
            return true
        }
    }
}
