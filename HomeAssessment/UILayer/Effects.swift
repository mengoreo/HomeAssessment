//
//  Effects.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation
import SwiftUI
//struct SearchViewController<Content: View>: UIViewControllerRepresentable {
//    @Binding var searchText: String
//    var content: () -> Content
//    let searchResultsView = UIView()
//
//    init(searchText: Binding<String>, @ViewBuilder content: @escaping () -> Content) {
//        self._searchText = searchText
//        self.content = content
//    }
//
//    func makeUIViewController(context: Context) -> UINavigationController {
//
//        let rootViewController = UIHostingController(rootView: EmptyView())
//        let navigationController = UINavigationController(rootViewController: rootViewController)
//        let searchResultsController = UIHostingController(rootView: content())
//
//        // Set nav properties
//        navigationController.navigationBar.prefersLargeTitles = true
//        navigationController.definesPresentationContext = true
//
//        // Create search controller
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.autocapitalizationType = .none
//        searchController.delegate =  context.coordinator
//        searchController.searchBar.delegate = context.coordinator // Monitor when the search button is tapped.
//
//        // Create default view
//        rootViewController.navigationItem.searchController = searchController
//        rootViewController.title = "Search"
//
//        return navigationController
//    }
//
//    func updateUIViewController(_ navigationController: UINavigationController, context: UIViewControllerRepresentableContext<SearchViewController>) {
//        //
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    final class Coordinator: NSObject, UISearchControllerDelegate, UISearchBarDelegate {
//        var parent: SearchViewController
//        init(_ parent: SearchViewController) {
//            self.parent = parent
//        }
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            parent.searchText = searchText
//        }
//    }
//}

extension Animation {
    public static var myease: Animation {
        return Animation.timingCurve(0.68, -0.33, 0.265, 1.55, duration: 0.87)
    }
    public static func myease(duration: Double = 0.87, delay: Double = 0) -> Animation {
        return Animation.timingCurve(0.68, -0.33, 0.265, 1.55, duration: duration).delay(delay)
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
