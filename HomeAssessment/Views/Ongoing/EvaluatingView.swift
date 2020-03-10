//
//  EvaluatingView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/7.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData
//struct EvaluatingView_Previews: PreviewProvider {
//    static var previews: some View {
//        EvaluatingView()
//    }
//}

struct EvaluatingView: View {
    @State var hideBackButton = false
    var assessment: Assessment
    var body: some View {
        Group {
            List {
                ForEach(assessment.standard!.getQuestions()) {question in
                    QuestionRowView(
                        viewModel: .init(assessment: self.assessment,
                                         question: question,
                                         hidehideNavigationBarBackButton: self.$hideBackButton
                        ))
                }
            }
        }
        .navigationBarTitle("\(assessment.remarks)", displayMode: .inline)
        .navigationBarItems(trailing: Group {
            if hideBackButton {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            } else {
                Text("")
            }
        })
        .navigationBarHidden(hideBackButton)
        .onAppear {
            AppStatus.update(hideTabBar: true)
        }
    }
}


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
                        CameraView(completionHandler: self.viewModel.captured(_:))
                }
            }
        }.padding(.vertical, 3)
    }
}
class QuestionRowViewModel: ObservableObject {
    
    @Published var cameraButtonTapped = false
    @Published var photosButtonTapped = false
    @Published var showWarning = false
    @Published var warningMessage = ""
    @Published var warningAction: ()-> Void = {}
    
    @Published var showARMeasureView = false
    @Published var savingImage = false
    var measurableOptionText: String {
        for option in question.getOptions() {
            if option.uuid == assessment.selectedOptions[question.uuid] {
                if option.to_val > 1000 {
                    return "结果在\(option.from_val)cm 以上"
                }
                return "结果在\(option.from_val)cm ～ \(option.to_val)cm 范围内"
            }
        }
        return ""
    }
    
    var photosButtonDisabled: Bool {
        print("** get photosButtonDisabled for \(question.uuid)")
        return assessment.getThumbnails(for: question.uuid).isEmpty
    }
    
    var question: Question
    var assessment: Assessment
    @Binding var hideNavigationBarBackButton: Bool
    init(assessment: Assessment, question: Question, hidehideNavigationBarBackButton: Binding<Bool>) {
        self.assessment = assessment
        self.question = question
        _hideNavigationBarBackButton = hidehideNavigationBarBackButton
    }
    var options: [Option] {
        question.getOptions() // update
    }
    
    var thumbnails: [ThumbnailImage] {
        assessment.getThumbnails(for: question.uuid)
    }
    
    func selectedAt(_ option: Option) -> Bool {
        assessment.selectedOptions[question.uuid] == option.uuid
    }
    func selected(_ option: Option) {
        objectWillChange.send()
        if !selectedAt(option) {
            assessment.selectedOptions[question.uuid] = option.uuid
        } else {
            assessment.selectedOptions.removeValue(forKey: question.uuid)
        }
        print("objectWillChange in selected option")
    }
    func captured(_ image: UIImage?) {
        objectWillChange.send()
        guard let image = image else {
            return
        }
        savingImage = true
        ThumbnailImage.performCreate(for: question.uuid, in: assessment, with: image) { (error, thumbnail) in
            guard error == nil else {
                fatalError((error! as NSError).userInfo["detail"] as! String)
            }
            DispatchQueue.main.async {
                self.savingImage = false
            }
        }
    }
    
    func measured(_ distance: Double) {
        for option in question.getOptions() {
            if distance > option.from_val && distance <= option.to_val {
                assessment.selectedOptions[question.uuid] = option.uuid
                break
            }
        }
        showARMeasureView = false
    }
    func willCaptureImage() {
        print("willCaptureImage")
        cameraButtonTapped.toggle()
    }
    
    func willShowPhotos() {
        print("willShowPhotos")
        photosButtonTapped.toggle()
    }
    
    
    func willDelete(_ thumbnail: ThumbnailImage) {
        warningMessage = "确定删除在 \(thumbnail.dateCreated!.dateString) 为 \(question.name) 拍摄的照片吗"
        warningAction =  {
            self.objectWillChange.send()
            thumbnail.delete()
            if self.thumbnails.isEmpty {
                self.photosButtonTapped = false
            }
        }
        showWarning = true
    }
}

struct OptionTextRowView: View {
    var text: String
    var selected: Bool
    var body: some View {
        HStack {
            Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                .foregroundColor(selected ? .darkGreen : Color(UIColor.tertiaryLabel))
            Text(text)
                .fontWeight(selected ? .bold : .regular)
                .animation(.myease)
        }.padding(.leading, 20)
        .accentColor(Color(UIColor.label))
        
    }
}

//struct CustomeHeader: View {
////    let name: String
//    var question: Question
//    @State var imageTapped = false
//    @State var cameraTapped = false
//    var completionHandler: (_ image: UIImage?, _ questionID: UUID) -> Void
//    var body: some View {
//        HStack {
//            Text(question.name)
//            HStack {
//                Button(action: {
//                    self.imageTapped.toggle()
//                }){
//                    Image(systemName: "photo.fill.on.rectangle.fill")
//                }.padding(.leading, 20)
//                .accentColor(.lightGreen) // change to dark green if has any image
//                    .sheet(isPresented: $imageTapped, content: {Text("image")})
//
//                Button(action: {self.cameraTapped.toggle()}){
//                    Image(systemName: "camera.fill")
//                }.padding(.leading, 20)
//                .accentColor(.darkGreen)
//                    .sheet(isPresented: $cameraTapped) {
//                        CameraView() { image in
//                            self.completionHandler(image, self.question.uuid)
//                        }
//                }
//            }
//        }
////        .padding(0)
////        .background(FillAll(color: Color(UIColor.systemBackground)))
//    }
//}
//
//struct FillAll: View {
//    let color: Color
//
//    var body: some View {
//        GeometryReader { proxy in
//            self.color.frame(width: proxy.size.width * 1.3, height: proxy.size.height * 1).border(Color(UIColor.systemFill))
//        }
//    }
//}
