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
