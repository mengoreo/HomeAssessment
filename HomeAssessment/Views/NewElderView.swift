//
//  NewElderView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/14.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import Combine
struct ElderInfo {
    var name: String
    var height: String
    var category: Int
}

struct NewElderView: View {
    @Binding var elder: ElderInfo
    private var categories = ["低龄自理", "高龄自理", "慢病自理", "专业照护", "长期卧床", "失智"]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(elder: Binding<ElderInfo> = .constant(ElderInfo(name: "", height: "", category: 2))) {
        self._elder = elder
    }
    var descriptionView = [
        Group{
            Text("身体健康，活力充沛，绝大多数时候无生活协助或生活助理的需求；") +
            Text("仍承担着重要的家庭角色。").bold()
        }, // 低龄自理
        Group{
            Text("身体基本健康，生活尚能自理，机体退化影响，存在生活隐患；") +
            Text("承担功能性的家庭角色").bold()
        }, // 高龄自理
        Group{
            Text("患有慢性疾病（如高血压、糖尿病等），生活自理，但需定期接受医疗服务；") +
            Text("承担较重要的家庭角色").bold()
        }, // 慢病自理
        Group{
            Text("为术后康复或重大疾病患者（如骨折、中风、心脑血管疾病等），需全天候的生活照护；") +
            Text("暂时性无法承担功能性角色").bold()
        }, // 专业照护
        Group{
            Text("完全或部分失能（如瘫痪、机能退化等），需全天侯的医疗生活照护；") +
            Text("暂时性或永久性无法承担功能性角色").bold()
        }, // 长期卧床
        Group{
            Text("失智（阿尔茨海默氏症、帕金森症、杭廷顿舞蹈症等），需全天候的生活照护；") +
            Text("已经无法承担功能性的家庭角色").bold()
        }, // 失智
    ]
    
    
    
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("个人信息").padding(.top, 20)){
                    CustomTextField("姓名", text: $elder.name, showClearButton: true, textColor: UIColor.label)
                    HStack {
                        CustomTextField("身高", text: $elder.height, showClearButton: true, textColor: UIColor.label)
                            .keyboardType(.numberPad)
                            .onReceive(Just(elder.height)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.elder.height = filtered
                                }
                            }
                        Spacer()
                        Text("厘米").foregroundColor(.secondary)
                        
                    }
                }
                
                Section(header:Text("老年人能力等级"),footer:
                    descriptionView[elder.category].font(.callout)
                ) {
                    
                    Picker("dddd",selection: $elder.category) {
                        ForEach(0 ..< categories.count, id: \.self) { index in
                            Text(self.categories[index]).tag(index).foregroundColor(.init(.label))
                        }
                    }
                    .labelsHidden()
                }
            }
            .navigationBarTitle("新建老人信息", displayMode: .inline)
            .navigationBarItems(
                leading:
                Button(action:{
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }){
                    Text("取消")
                }, 
                trailing: Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }){Text("完成")})
        }.accentColor(.lightGreen)
    }
}
