//
//  AssessmentListView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct AssessmentListView: View {
    @ObservedObject var viewModel: AssessmentListViewModel
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.assessments) {assessment in
                    Button(action:{
                        self.viewModel.update(assessment)
                    }){
                        VStack(alignment: .leading) {
                            Text(assessment.remarks)
                            Spacer().frame(height: 3)
                            Text("\(assessment.standard?.name ?? "No Standard")")
                            Text("elders: \(assessment.getElders().count)")
                        }
                    }
                }.onDelete(perform: {(offsets) in
                    for index in offsets {
                        self.viewModel.assessments[index].delete()
                    }
                })

                .navigationBarTitle("我的评估")
                .navigationBarItems(
                    leading:
                        Image.icon.resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                    ,trailing:
                        HStack {
                            Button(action:{
    //                            self.viewModel.displayActionSheet.toggle()
                            }){
                                Image.ellipsisCircleFill
                            }
                            Spacer().frame(width: 20)
                            Button(action:{
                                self.viewModel.createNewAssessment()
                            }){
                                Image.plusCircleFill
                            }
                        }
                    )
            }
            .onAppear(perform: viewModel.onAppear)
            Text("").hidden().sheet(isPresented: $viewModel.showNewAssessmentModal) {
                Text("to be implemen")
//                NewEditAssessmentView(viewModel: .init(assessment: self.viewModel.assessmentToCreateOrEdit!))
            }
        }
        .accentColor(Color("DarkGreen"))
    }
}

struct AssessmentListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE"], id: \.self) { deviceName in
            AssessmentListView(viewModel: .init())
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
