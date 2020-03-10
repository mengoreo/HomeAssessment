//
//  OptionTextRowView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct OptionTextRowView: View {
    var text: String
    var selected: Bool
    var body: some View {
        HStack {
            Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                .foregroundColor(selected ? .darkGreen : Color(UIColor.tertiaryLabel))
            Text(text)
                .fontWeight(selected ? .bold : .regular)
                .animation(.myease)
        }.padding(.leading, 20)
        .accentColor(Color(UIColor.label))
        
    }
}
