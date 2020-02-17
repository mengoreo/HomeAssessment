//
//  TestPicker.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/14.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

import SwiftUI

struct MyTextPreferenceKey: PreferenceKey {
    typealias Value = [MyTextPreferenceData]

    static var defaultValue: [MyTextPreferenceData] = []
    
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct MyTextPreferenceData: Equatable {
    let viewIdx: Int
    let rect: CGRect
}

struct CustomPickerView : View {
    
    @Binding private var activeIdx: Int
//    @State private var rects: [CGRect] = Array<CGRect>(repeating: CGRect(), count: self.dataCount)
    private var data: [String]
    private var dataCount: Int {
        return data.count
    }
    
    init(data: [String], activeIdx: Binding<Int>) {
        self.data = data
        self._activeIdx = activeIdx
//        self.rects = Array<CGRect>(repeating: CGRect(), count: data.count)
    }
    var body: some View {
        
        GeometryReader {proxy in
            VStack(spacing: 0) {
//                Spacer()
                MonthView(activeMonth: self.$activeIdx, label: self.data[0], idx: 0).frame(width: proxy.frame(in: .global).width / CGFloat(self.data.count + 1))
                
                ForEach(1 ..< self.data.count) { index in
                    HStack{
//                        Spacer()
//                        Divider().frame(height: proxy.frame(in: .global).height * 0.6)
                        MonthView(activeMonth: self.$activeIdx, label: self.data[index], idx: index).frame(width: proxy.frame(in: .global).width / CGFloat(self.data.count + 1))
                    }
                }
//                Spacer()
            }.aspectRatio(0.75, contentMode: .fit)
        }
    }
}

struct MonthView: View {
    @Binding var activeMonth: Int
    let label: String
    let idx: Int
    
    var body: some View {
        GeometryReader { proxy in
            Text(self.label)
                .foregroundColor(self.activeMonth == self.idx ? Color.init(UIColor.label) :  Color.init(UIColor.secondaryLabel))
//                .font(.system(size: proxy.frame(in: .global).width * 0.2))
                .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(lineWidth: 3.0).foregroundColor(.lightGreen)
                    .frame(width: self.activeMonth == self.idx ? proxy.frame(in: .global).width : 0, height: self.activeMonth == self.idx ? proxy.frame(in: .global).height * 0.8 : 0)
                    .opacity(self.activeMonth == self.idx ? 1 : 0)
                    .animation(.myease)
                )
                .padding(proxy.frame(in: .global).width * 0.01)
                .background(MyPreferenceViewSetter(idx: self.idx))
                .onTapGesture {
                    self.activeMonth = self.idx
                }
        }
    }
}

struct MyPreferenceViewSetter: View {
    let idx: Int
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: MyTextPreferenceKey.self,
                            value: [MyTextPreferenceData(viewIdx: self.idx, rect: geometry.frame(in: .named("myZstack")))])
        }
    }
}


