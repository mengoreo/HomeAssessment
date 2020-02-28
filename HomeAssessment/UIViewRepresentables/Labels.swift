//
//  Labels.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

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
