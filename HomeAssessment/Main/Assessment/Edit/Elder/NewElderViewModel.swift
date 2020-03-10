//
//  NewElderViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct ElderInfo {
    var name: String
    var height: String
    var category: Int
}

class NewElderViewModel: NSObject, ObservableObject {
    @Published var elderInfo: ElderInfo
//    @Published var presentationMode: PresentationMode
    var categories = ["低龄自理", "高龄自理", "慢病自理", "专业照护", "长期卧床", "失智"]
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
    
    private var assessment: Assessment
    var elder: Elder?
    var barTitle: String!
    
    init(assessment: Assessment, elder: Elder? = nil) {
        self.elder = elder
        if elder == nil {
            self.elderInfo = ElderInfo(name: "fake", height: "100", category: 2)
        } else {
            self.elderInfo = ElderInfo(name: elder!.name, height: "\(elder!.heightInCM)", category: categories.firstIndex(of: elder!.status) ?? 2)
        }
        
        self.assessment = assessment
        super.init()
        barTitle = elderInfo.name.isEmpty ? "新建老人信息" : elderInfo.name
    }
    
    var disableDoneButton: Bool {
        return elderInfo.name.isEmpty || elderInfo.height.isEmpty
    }
    
    func save() {
        // check height later
        if elder != nil {
            elder!.update(name: elderInfo.name, heightInCM: elderInfo.height.intValue, status: categories[elderInfo.category])
        } else {
            let e = Elder.create(name: elderInfo.name, heightInCM: elderInfo.height.intValue, status: categories[elderInfo.category])
            e.setPrimitiveValue(assessment, forKey: "assessment")
        }
        
    }
    
    
}
