//
//  NewElderView.swift
//  tet
//
//  Created by Mengoreo on 2020/2/23.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI


struct NewElderView: View {
    
    @ObservedObject var viewModel: NewElderViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>    
    var body: some View {
        Form {
            Section(header: Text("个人信息").padding(.top, 20)){
                TextField("姓名", text: $viewModel.elderInfo.name)

                HStack {
                    TextField("身高", text: $viewModel.elderInfo.height)
                    Spacer()
                    Text("厘米").foregroundColor(.secondary)
                    
                }
            }
            
            Section(header:Text("老年人能力等级"),footer:
                viewModel.descriptionView[viewModel.elderInfo.category].font(.callout)
            ) {
                
                Picker("dddd",selection: $viewModel.elderInfo.category) {
                    ForEach(0 ..< viewModel.categories.count, id: \.self) { index in
                        Text(self.viewModel.categories[index]).tag(index).foregroundColor(.init(UIColor.label))
                    }
                }
                .labelsHidden()
            }
        }
        .navigationBarTitle("\(viewModel.barTitle)", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action:{
                self.viewModel.save()
                self.presentationMode.wrappedValue.dismiss()
            }){Text("完成")}.disabled(viewModel.disableDoneButton))
        
    }
}

