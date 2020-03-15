//
//  NewEditAssessmentView.swift
//  tet
//
//  Created by Mengoreo on 2020/2/23.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData
import MapKit

struct NewEditAssessmentView: View {
    
    @ObservedObject var viewModel: NewEditAssessmentViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("备注")) {
                    CustomTextField("请输入备注，留空则为住宅地址",
                                    text: $viewModel.remarks,
                                    showClearButton: true,
                                    disabled: viewModel.saving,
                                    returnKeyType: .done,
                                    didBeginEditing: viewModel.didBeginEditingRemarks,
                                    didEndEditing: viewModel.didEndEditingRemarks)
                }
                
                ContactSectionView(viewModel: .init(assessment: viewModel.assessment))
                    .disabled(viewModel.editingRemarks || viewModel.saving)

                
                ElderSectionView(viewModel: .init(assessment: viewModel.assessment))
                    .disabled(viewModel.editingRemarks || viewModel.saving)

                Picker("", selection: $viewModel.selectedStandardIndex) {
                    ForEach(self.viewModel.standards.indices, id:\.self) { index in
                        Text(self.viewModel.standards[index].name)
                            .tag(index).foregroundColor(.init(UIColor.label))
                    }
                }
                .labelsHidden()
                
                Section(header: Text("住宅地址")) {
                    Button(action:{
                        self.viewModel.presentingMap.toggle()
                    }) {
                        Text("\((viewModel.locatedAt?.address() ?? "点击搜索位置"))")
                    }
                        .sheet(isPresented: $viewModel.presentingMap) {
                            SearchMapView(selectedPlace: self.$viewModel.locatedAt,
                                          handleTapOnMapCallout: self.viewModel.didSelect(_:))
                                .edgesIgnoringSafeArea(.all)
                    }
                }
                .disabled(viewModel.editingRemarks || viewModel.saving)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("\(viewModel.barTitle)", displayMode: .inline)
            .navigationBarItems(
                leading:
                Button(action:{
                    self.viewModel.cancel()
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("取消")
                }.disabled(viewModel.saving),
                
                trailing: Button(action:{
                    self.viewModel.save() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }){
                    if viewModel.saving {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    } else {
                        Text("保存")
                    }
                    
                }.disabled(viewModel.doneButtonDisabled || viewModel.saving)
            )
            .navigationBarBackButtonHidden(true)
        }
    }
    
    
}



