//
//  AssessmentListView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct AssessmentListView: View {
    var rowHeight = Device.width / 5
    
    @ObservedObject var viewModel: AssessmentListViewModel
    
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SignInUpView(viewModel: .init(from: .init()))) {
                    HStack(alignment: .center) {
                        Button(action:{
                            print("** add row")
                        }){
                            Image.mapPreviewLight.resizable()
                        }
                        .buttonStyle(ImageButtonStyle(width: rowHeight, height: rowHeight))
                        .padding(.bottom, 5)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("万亭花园").font(.headline)
                            Text("评估进度：33%").font(.subheadline)
                                .foregroundColor(.secondary)
                        }.alignmentGuide(VerticalAlignment.center
                            , computeValue: {_ in 27})
                        Spacer()
                        Text("9:31")
                        .foregroundColor(.secondary)
                    }
                }.buttonStyle(PlainButtonStyle())

            }
            .sheet(isPresented: $viewModel.adding) {
                NewAssessmentView()
            }
            .navigationBarTitle("我的评估", displayMode: .automatic)
            .navigationBarItems(
                leading:
                    Image.icon.resizable()
                        .frame(width: viewModel.imgWidth, height: viewModel.imgWidth, alignment: .center)
                        .offset(x: viewModel.imgXOffset, y: viewModel.imgYOffset).animation(.myease)
                ,trailing:
                
                    HStack {
                        Button(action:{
                            self.viewModel.displayActionSheet.toggle()
                        }){
                            Image.ellipsisCircleFill.scaleEffect(1.3)
                        }
                        Spacer().frame(width: 20)
                        Button(action:{
                            self.viewModel.adding.toggle()
                        }){
                            Image.plusCircleFill.scaleEffect(1.3)
                        }
                    }
                )
        }
        .accentColor(Color("DarkGreen"))
        .onAppear {
            self.viewModel.readyForDisplay()            
        }
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
