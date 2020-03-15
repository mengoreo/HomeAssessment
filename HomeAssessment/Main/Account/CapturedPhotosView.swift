//
//  CapturedPhotosView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/14.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData
struct CapturedPhotosView: View {
    @ObservedObject var viewModel = CapturedPhotosViewModel()
    var body: some View {
        Group {
            if viewModel.noPhotos {
                Text("还没拍摄照片")
            } else {
                List {
                    ForEach(viewModel.photoRowModels) { photoRowModel in
                        if !photoRowModel.photos.isEmpty {
                            QuestionImageRow(title: photoRowModel.category, thumbnails: photoRowModel.photos, deleteAction: self.viewModel.delete, sepcified: false)
                        }
                    }
                }.listStyle(PlainListStyle())
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .navigationBarTitle("我的照片")
    }
}

class CapturedPhotosViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    var photoRowModels: [PhotoRowModel] {
        var rows = [PhotoRowModel]()
        for assessment in UserSession.currentUser.assessments ?? [] {
            rows.append(.init(assessment))
        }
        return rows
    }
    @Published var fetchingPhotos = true
    var noPhotos: Bool {
        var allNone = true
        for assessment in UserSession.currentUser.assessments ?? [] {
            allNone = allNone && assessment.capturedImages?.isEmpty ?? true
        }
        return allNone
    }
    
    override init() {
        super.init()
        Assessment.resultController.delegate = self
    }
    func onAppear() {
        print("oneppear")
        try? Assessment.resultController.performFetch()
        
    }
    func delete(_ thumbnail: ThumbnailImage) {
        thumbnail.delete()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
}

struct PhotoRowModel: Identifiable {
    let id: Double // time stamp
    let category: String
    let photos: [ThumbnailImage]
    
    init(_ assessment: Assessment) {
        id = assessment.dateUpdated?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        category = assessment.remarks
        photos = assessment.capturedImages?.sorted(by: {return $0.dateCreated!.timeIntervalSince1970 > $1.dateCreated!.timeIntervalSince1970}) ?? []
    }
    
}
