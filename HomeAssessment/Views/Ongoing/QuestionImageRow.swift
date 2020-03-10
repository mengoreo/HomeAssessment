//
//  QuestionImageRow.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData

//struct CapturedImagesView: View {
//    @ObservedObject var viewModel: CapturedImagesViewModel
//
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    var body: some View {
//        NavigationView {
//            List {
//                if viewModel.updating {
//                    HStack {
//                        Spacer()
//                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
//                        Spacer()
//                    }
//                }
//                // need to add id: \.self for observing changes
//                ForEach(viewModel.thumbnails, id: \.self) { index in
//                    QuestionImageRow(viewModel: .init(questionId: self.viewModel.keys[index], assessment: self.$viewModel.assessement))
//                }
//            }.navigationBarTitle(viewModel.assessement.remarks)
//                .navigationBarItems(trailing: Button(action: {
//                    self.presentationMode.wrappedValue.dismiss()
//                }){
//                    Image(systemName: "xmark").imageScale(.large)
//                })
//
//        }.onAppear(perform: viewModel.onAppear)
//    }
//}

//class CapturedImagesViewModel: ObservableObject {
//    var assessement: Assessment
//    var questionID: UUID
//    init(assessement: Assessment, questionID: UUID) {
//        self.assessement = assessement
//        self.questionID = questionID
//    }
//
//    @Published var updating = false
//    @Published var thumbnails = [ThumbnailImage]()
//
//    func onAppear() {
////        objectWillChange.send()
//        self.updating = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.thumbnails = self.assessement.getThumbnails(for: self.questionID)
//            self.updating = false
//        }
//    }
//}
//
//class QuestionImageRowModel: ObservableObject {
////    var question: Question
//    var title: String?
//    var thumbnails: [ThumbnailImage]
//    init(thumbnails: [ThumbnailImage], title: String? = nil) {
//        self.thumbnails = thumbnails
//        self.title = title
//    }
////
////    lazy var thumbnailsController: NSFetchedResultsController<ThumbnailImage> = {
////        let tc = ThumbnailImage.resultController
////        tc.delegate = self
////        return tc
////    }()
//
////    var thumbnails: [ThumbnailImage] {
////        print("** getting thumbnails of \(question.name)")
////        return thumbnailsController.fetchedObjects?.filter{$0.uuid == question.uuid} ?? []
////    }
//
//    @Published var updating = false
//    @Published var editing = false
//    @Published var deleteButtonTapped = false
//
//
//    func onAppear() {
//        objectWillChange.send()
//        updating = true
////        try? thumbnailsController.performFetch()
//        updating = false
//    }
//
//
//    func handleDelete(_ image: ThumbnailImage) {
//        print("about to delete \(image) for \(title ?? "nil")")
//        objectWillChange.send()
//        CoreDataHelper.stack.context.delete(image)
////        objectWillChange.send()
//    }
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        objectWillChange.send()
//        print("Thumbnails will change")
//    }
//}

struct QuestionImageRow: View {
//    @ObservedObject var viewModel: QuestionImageRowModel
    var title: String?
    var thumbnails: [ThumbnailImage]
    var deleteAction: (_ thumbnail: ThumbnailImage)->Void
    
//    @State var updating = false
    @State var editing = false
    @State var deleteButtonTapped = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if title != nil {
                    Text(title!)
                        .font(.headline)
                }
                
                Spacer()
                
                Button(action: {
                    self.editing.toggle()
                }) {
                    Text("\(self.editing ? "完成" : "编辑")")
                        .foregroundColor(.accentColor)
                }
            }
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    if self.thumbnails.isEmpty {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    }
                    ForEach(self.thumbnails, id: \.self) { thumbnail in
                        self.itemView(of: thumbnail)
                    }
                }
            }
            .padding(.top, 15)
        }.onAppear {
            self.editing = false
        }
        .onDisappear {
            print("** item image disappeared")
            self.editing = false
        }
    }
    
    func itemView(of thumbnail: ThumbnailImage) -> some View {
        ZStack {
            NavigationLink(destination:
                Image(uiImage: thumbnail.uiImage)
                    .resizable()
                    .scaledToFit()
            ) {
                ZStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    if !thumbnail.isDeleted {
                        CategoryItem(image: thumbnail.uiImage, caption: (thumbnail.dateCreated ?? Date()).dateString)
                    }
                }
                
            }
                .scaleEffect(self.editing ? 0.7 : 1)
                .animation(.myease)
                .disabled(self.editing)
            
            Button (action: {
                self.deleteAction(thumbnail)
            }) {
                Image(systemName: "trash.fill")
                    .resizable()
                    .scaleEffect(0.5)
                    .foregroundColor(Color(UIColor.systemRed))
                    .shadow(radius: 7)
                    .padding(.bottom, 7)
                    .padding(.leading, 3)
                
            }
            .padding()
            .opacity(self.editing ? 1 : 0)
            .animation(.myease)
        }
    }
    
}

struct CategoryItem: View {
    var image: UIImage
    var caption: String
    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: image)
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(caption)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}
