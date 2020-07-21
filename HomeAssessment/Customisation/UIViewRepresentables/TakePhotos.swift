//
//  TakePhotos.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI


struct CameraView: UIViewControllerRepresentable {
    
    var completionHandler: (_ capturedImage: UIImage?) -> Void
    
    init(completionHandler: @escaping (_ capturedImage: UIImage?) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .photoLibrary
        } else {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
        }
        
        imagePickerController.delegate = context.coordinator
        
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            guard let image = info[.originalImage] as? UIImage else {
                parent.completionHandler(nil)
                return
            }
            parent.completionHandler(image)
        }
    }
}
