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
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if isAnimating {
            uiView.startAnimating()
            animationStarted()
        } else {
            uiView.stopAnimating()
            
        }
    }
}
