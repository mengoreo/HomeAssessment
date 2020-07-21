//
//  QuestionRowViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI


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
    
    func measured(_ distance: Double) {
        // MARK: - 测量完成
        for option in question.getOptions() {
            if distance > option.from_val && distance <= option.to_val {
                assessment.selectedOptions[question.uuid] = option.uuid
                break
            }
        }
        // MARK: - 隐藏测量视图
        showARMeasureView = false
    }
    func willCaptureImage() {
        // MARK: - 显示拍照视图
        cameraButtonTapped.toggle()
    }
    func captured(_ image: UIImage?) {
        objectWillChange.send()
        guard let image = image else {
            return
        }
        savingImage = true // MARK: - 等待保存完成
        ThumbnailImage.performCreate(for: question.uuid, in: assessment, with: image) { (error, thumbnail) in
            guard error == nil else {
                // MARK: - 向用户展示错误信息
                self.showError((error! as NSError).userInfo["detail"] as! String)
                return
            }
            DispatchQueue.main.async {
                self.savingImage = false // MARK: - 保存完成
            }
        }
    }
    
    func willShowPhotos() {
        print("willShowPhotos")
        photosButtonTapped.toggle()
    }
    
    func showError(_ detail: String) {
        
    }
    func willDelete(_ thumbnail: ThumbnailImage) {
        warningMessage = "确定删除在 \(thumbnail.dateCreated!.relevantString) 为 \(question.name) 拍摄的照片吗"
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
