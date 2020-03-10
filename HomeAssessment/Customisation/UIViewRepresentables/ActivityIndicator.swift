//
//  ActivityIndicator.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    var animationStarted: () -> Void = {}
    var color: UIColor? = nil
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if color != nil {
            uiView.color = color
        }
        if isAnimating {
            uiView.startAnimating()
            animationStarted()
        } else {
            uiView.stopAnimating()
        }
    }
}
