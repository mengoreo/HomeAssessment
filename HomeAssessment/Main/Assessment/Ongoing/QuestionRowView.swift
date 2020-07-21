//
//  QuestionRowView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct QuestionRowView: View {
    @ObservedObject var viewModel: QuestionRowViewModel
    var body: some View {
        Section(header: HeaderView()) {
            if viewModel.photosButtonTapped && !viewModel.thumbnails.isEmpty {
                QuestionImageRow(thumbnails: viewModel.thumbnails, deleteAction: viewModel.willDelete)
            }
            if !self.viewModel.question.measurable {
                ForEach(self.viewModel.options) { option in
                    Button(action: {
                        self.viewModel.selected(option)
                    }) {
                        OptionTextRowView(text: option.optionDescription, selected: self.viewModel.selectedAt(option))
                    }
                }
            } else {
                // measurable option row
                Button(action: {
                    self.viewModel.showARMeasureView.toggle()
                }) {
                    Group {
                        Text(self.viewModel.measurableOptionText)
                        Text(self.viewModel.measurableOptionText.isEmpty ? "点击测量" : "点击重新测量")
                            .foregroundColor(.accentColor)
                        .sheet(isPresented: $viewModel.showARMeasureView) {
                            ARMeasureView(doneAction: self.viewModel.measured(_:))
                        }
                    }
                    
                }.padding(.leading, 20)
            }
        }
        .actionSheet(isPresented: $viewModel.showWarning) {
            ActionSheet(title: Text("\(viewModel.warningMessage)"), message: nil, buttons: [.cancel(Text("取消")), .destructive(Text("确定"), action: viewModel.warningAction)])
        }
        
    
    }
    
    func HeaderView() -> some View {
        HStack {
            Text(viewModel.question.name)
            HStack {
                Button(action:viewModel.willShowPhotos){
                    ZStack {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .opacity(self.viewModel.savingImage ? 0 : 1)
                        
                        VStack {
                            Spacer()
                            ActivityIndicator(isAnimating: .constant(true), style: .medium)
                            Spacer()
                        }
                            .opacity(self.viewModel.savingImage ? 1 : 0)
                    }.animation(.default)
                }.disabled(viewModel.photosButtonDisabled)
                .padding(.leading, 20)
                .accentColor(.lightGreen)
                
                Button(action: viewModel.willCaptureImage){
                    Image(systemName: "camera.fill")
                }
                .padding(.leading, 20)
                .accentColor(.darkGreen)
                    .sheet(isPresented: $viewModel.cameraButtonTapped) {
                        CameraView(completionHandler: self.viewModel.captured(_:)).edgesIgnoringSafeArea(.all)
                }
            }
        }.padding(.vertical, 3)
    }
}
