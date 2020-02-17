//
//  NewAssessmentView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/14.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct NewAssessmentView: View {
    @State var remarks = "ddd"
    @State var newElderModal: Bool = false
    @State var editElder: Bool = false
    @State var searchStandardModal: Bool = false
    
    @State var selectedStandard = ""
    @State var elderNames = ["张三", "李四"]
    @State var addElderModal = false
    
    @State var mode: EditMode = .inactive
    
    
    func editModeOn() -> Bool {
        return mode == .active
    }
    func toggleEditMode() {
        if editModeOn() {
            $mode.animation().wrappedValue = .inactive
        } else {
            $mode.animation().wrappedValue = .active
        }
    }
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("备注")) {
                    CustomTextField(text: $remarks, showClearButton: true, disabled: editModeOn(), textColor: .label)
                        .foregroundColor(.init(UIColor.tertiaryLabel))
                }
                
                Section(header: Text("联系人")) {
                    CustomTextField("姓名", text: $remarks, showClearButton: true, disabled: editModeOn(), textColor: .label)
                    CustomTextField("联系电话", text: $remarks, showClearButton: true, disabled: editModeOn(), textColor: .label)
                    Button(action:{}){
                        HStack{
                            Text("点击获取地址")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .opacity(self.editElder ? 0 : 1)
                                .animation(.myease)
                        }
                        .sheet(isPresented: .constant(false)) {
                            Text("位置")
                        }
                    }.accentColor(.darkGreen).disabled(editModeOn())
                }
                
                Section(header:
                    HStack {
                        Text("家中老人")
                        Spacer()
                        Button(action: {
                            self.toggleEditMode()
                        }){
                            Text(editModeOn() ? "完成" : "编辑")
                                .font(.headline)
                        }.accentColor(.darkGreen)
                    }
                ) {
                    ForEach(elderNames, id: \.self) { name in
                        Button(action: {
                            self.editElder.toggle()
                        }) {
                            HStack {
                                Text(name)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .opacity(self.editElder ? 0 : 1)
                            }
                        }.accentColor(.darkGreen)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                    
                    Button(action: {self.newElderModal.toggle()}){
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("添加老人信息")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .opacity(self.editElder ? 0 : 1)
                                .animation(.myease)
                            
                        }
                    }
                    .accentColor(.darkGreen).disabled(editModeOn())
                    .sheet(isPresented: $newElderModal) {
                        NewElderView()
                    }
                }
                
                Section(header: Text("选择标准")) {
                    
                    Button(action: {self.searchStandardModal.toggle()}) {
                        HStack {
                            Text(selectedStandard.isEmpty ? "添加标准" : selectedStandard)
                                .accentColor(selectedStandard.isEmpty ? .darkGreen : .black)
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .opacity(self.editElder ? 0 : 1)
                                .animation(.myease)
                        }
                        .sheet(isPresented: $searchStandardModal) {SearchStandardView(selected: self.$selectedStandard)}
                    }.disabled(editModeOn())
                }
            }
            .environment(\.editMode, .some($mode))
            .listStyle(GroupedListStyle())
            .navigationBarTitle("新建评估", displayMode: .inline)
        }
    }
    
    func delete(at offset: IndexSet) {
        if let index = offset.first {
            elderNames.remove(at: index)
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        elderNames.move(fromOffsets: source, toOffset: destination)
    }
}

extension EditMode {

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
struct NewAssessmentView_Previews: PreviewProvider {
    static var previews: some View {
        NewAssessmentView()
    }
}
