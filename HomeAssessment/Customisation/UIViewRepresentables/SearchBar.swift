//
//  SearchBar.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

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
