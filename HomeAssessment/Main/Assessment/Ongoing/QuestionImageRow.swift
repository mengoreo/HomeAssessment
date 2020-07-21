//
//  QuestionImageRow.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/8.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData

struct QuestionImageRow: View {
    var title: String?
    var thumbnails: [ThumbnailImage]
    var deleteAction: (_ thumbnail: ThumbnailImage)->Void
    var sepcified = true
    @State var editing = false
    @State var deleteButtonTapped = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if title != nil {
                    Text(title!)
                        .font(.title)
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
                VStack {
                    Image(uiImage: thumbnail.uiImage)
                        .resizable()
                        .scaledToFit()
                    Text(caption(of: thumbnail))
                        .multilineTextAlignment(.leading)
                }
            ) {
                ZStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    if !thumbnail.isDeleted {
                        CategoryItem(image: thumbnail.uiImage,
                                     caption: caption(of: thumbnail))
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
    
    func caption(of thumbnail: ThumbnailImage) -> String {
        if !sepcified {
            if let question = Question.findById(with: thumbnail.questionID ?? UUID()) {
                return question.name
            }
            return ""
        } else {
            return (thumbnail.dateCreated ?? Date()).relevantString
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
                .frame(width: 155)
                .lineLimit(1)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}
