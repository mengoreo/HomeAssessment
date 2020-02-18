//
//  ImagesView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/17.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

extension Image {
    public static var mapPreviewLight: Image {
        return Image("mapPreviewLight")
    }
    public static var mapPreviewDark: Image {
        return Image("mapPreviewDark")
    }
    public static var icon: Image {
        return Image("icon")
    }
    public static var moreCircleFill: some View {
        ZStack {
            Image(systemName: "circle.fill").foregroundColor(.init(UIColor.tertiarySystemFill))
            Image(systemName: "ellipsis")
                .foregroundColor(.darkGreen).scaleEffect(0.7)
        }
    }
    public static var plusCircleFill: some View {
        ZStack {
            Image(systemName: "circle.fill").foregroundColor(.darkGreen)
            Image(systemName: "plus")
                .foregroundColor(.white).scaleEffect(0.7)
        }
    }
    public static var plusColorful: some View {
        
        GeometryReader { geo in
            ZStack {                
                Image(systemName: "circle").frame(width: geo.frame(in: .global).height, height: geo.frame(in: .global).height).foregroundColor(.red).mask(Rectangle().padding(.bottom, geo.frame(in: .global).height / 2 + 0.5)).mask(Rectangle().padding(.trailing, geo.frame(in: .global).height / 2 + 0.5)).opacity(0.3)
                
                Image(systemName: "circle").frame(width: geo.frame(in: .global).height, height: geo.frame(in: .global).height).foregroundColor(.yellow).mask(Rectangle().padding(.bottom, geo.frame(in: .global).height / 2 + 0.5)).mask(Rectangle().padding(.leading, geo.frame(in: .global).height / 2 + 0.5)).opacity(0.3)
                
                Image(systemName: "circle").frame(width: geo.frame(in: .global).height, height: geo.frame(in: .global).height).foregroundColor(.blue).mask(Rectangle().padding(.top, geo.frame(in: .global).height / 2 + 0.5)).mask(Rectangle().padding(.leading, geo.frame(in: .global).height / 2 + 0.5)).opacity(0.3)
                
                Image(systemName: "circle").frame(width: geo.frame(in: .global).height, height: geo.frame(in: .global).height).foregroundColor(.green).mask(Rectangle().padding(.top, geo.frame(in: .global).height / 2 + 0.5)).mask(Rectangle().padding(.trailing, geo.frame(in: .global).height / 2 + 0.5)).opacity(0.3)
                
                Image(systemName: "plus").scaleEffect(0.7).foregroundColor(.darkGreen)
            }
        }
    }
}

