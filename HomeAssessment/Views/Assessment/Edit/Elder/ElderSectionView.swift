//
//  ElderSectionView.swift
//  tet
//
//  Created by Mengoreo on 2020/2/24.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct ElderSectionView: View {
    @ObservedObject var viewModel: ElderSectionViewModel
    
    var body: some View {
        Group { // for on appear to work
            Section(header:Text("家中老人")) {
                
                ForEach(viewModel.elders) { elder in
                    
                    NavigationLink(destination: NewElderView(viewModel: .init(assessment: self.viewModel.assessment, elder: elder))) {
                        Text(elder.name)
                            .contextMenu {
                                Button(action:{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                        elder.delete()
                                    }
                                }) {
                                    Text("删除")
                                    Image(systemName: "trash.circle")
                                }
                            }
                    }
                    

                }.onDelete(perform: viewModel.delete(at:))
                
                
                NavigationLink(destination: NewElderView(viewModel: .init(assessment: viewModel.assessment))) {
                    Button(action: {}){
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("添加老人信息")
                                .accentColor(Color(UIColor.label))
                        }
                    }
                }
            }.onAppear(perform: viewModel.onAppear)
        }
    }
}

