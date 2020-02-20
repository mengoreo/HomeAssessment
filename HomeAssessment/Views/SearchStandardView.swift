//
//  SearchStandardView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/15.
//  Copyright © 2020 Mengoreo. All rights reserved.
//
import SwiftUI
import Combine
struct SearchStandardView: View {
    let array = ["Standard-1", "Standard-7", "Standard-3", "Standard-4", "Standard-5", "Standard-6", "Standard-8", "中国居家养老住宅适老化评估标准ddddddd"]
    @State private var searchText = ""
    @Binding var selected: String
    func filter(_ text: String) -> [String] {
        return array.filter {text.isEmpty ? true : $0.localizedStandardContains(text)}
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        SearchModalView("搜索标准", searchedText: $searchText, barTitle: "选择标准") { result in
            List {
                ForEach(self.filter(result), id: \.self) { name in
                    SelectableRow(selected: name == self.selected, action: {
                        self.selected = name
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(name)
                    }
                }

            }
        }
        .accentColor(.lightGreen)
        
    }
}



struct SearchStandardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchStandardView(selected: .constant(""))
              .environment(\.colorScheme, .light)

            SearchStandardView(selected: .constant(""))
              .environment(\.colorScheme, .dark)
        }
    }
}


