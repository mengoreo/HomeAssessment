//
//  test.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/13.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct test: View {
    
    @State var isAnimating: Bool = false
    @State var animatedValue: Double = 0
    private var startingTime = 0
    private var endingTime = 0
    var body: some View {
        VStack {
            Spacer()
            Icon(width: 200, height: 200, isAnimating: $isAnimating)
            Spacer()
            HStack{
                Button(action: {
                    withAnimation(Animation.linear.repeatForever(autoreverses: false)){
                        self.isAnimating = true
                    }
                    
                }) {
                    Text("start")
                }.buttonStyle(CollapsableGradientBackgroundStyle())
                Button(action: {
                    withAnimation(Animation.myease){
                        self.isAnimating = false
                    }
                }) {
                    Text("stop")
                }.buttonStyle(CollapsableGradientBackgroundStyle())
            }
            Spacer()
        }
    }
}


struct CustomRotationEffect: GeometryEffect {

    var offsetValue: Double // 0...1
    @Binding var result: Double
    
    var animatableData: Double {
        get { offsetValue }
        set {
            offsetValue = newValue
            
            
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let angle = offsetValue
        print("*** rotating: \(offsetValue) - \(DispatchTime.now().rawValue)")
        DispatchQueue.main.async {
            
            self.result = self.offsetValue
            
        }
        let affineTransform = CGAffineTransform(translationX: size.width*0.5, y: size.height*0.5)
        .rotated(by: CGFloat(angle))
        .translatedBy(x: -size.width*0.5, y: -size.height*0.5)
        
        return ProjectionTransform(affineTransform)
    }
}
struct ShowSize: View {
    var body: some View {
        GeometryReader { proxy in
            Text("\(proxy.frame(in: .global).animatableData.first.second)")
//                .foregroundColor(.white)
        }
    }
}
struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
