//
//  CustomStyles.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/18.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct CollapsableGradientBackgroundStyle: ButtonStyle {
    
    var collapsed: Bool = false
    var colors: [Color] = [Color("DarkGreen"), Color("LightGreen")]
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: collapsed ? 30 : .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, collapsed ? 0 : 20)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct ImageButtonStyle: ButtonStyle {
    var width: CGFloat = Device.height / 7
    var height: CGFloat = Device.height / 7
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height, alignment: .center)
            .shadow(radius: configuration.isPressed ? 0 : 3.0)
            .padding(3)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct CollapsableOutlineBackgroundStyle: ButtonStyle {
    var collapsed: Bool = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: collapsed ? 30 : .infinity)
            .padding()
            .foregroundColor(.darkGreen)
            .cornerRadius(40)
            .padding(.horizontal, collapsed ? 0 : 20)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.darkGreen, lineWidth: 3)
                    .padding(.horizontal, collapsed ? 0 : 20)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
