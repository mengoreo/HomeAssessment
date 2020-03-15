//
//  ReportListView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/14.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import PDFKit

struct ReportListView: View {
    @ObservedObject var viewModel = ReportListViewModel()
    var body: some View {
        Group {
            if viewModel.assessments.isEmpty {
                Text("还没有生成评估报告")
            } else {
                List {
                
                    ForEach(viewModel.assessments) {assessment in
                        ReportRowView(viewModel: .init(assessment))
                    }
                
                }.listStyle(PlainListStyle())
            }
        }.onAppear(perform: viewModel.onAppear)
        .navigationBarTitle("我的评估报告")
    }
}

class ReportListViewModel: ObservableObject {
    var assessments: [Assessment] {
        UserSession.currentUser.assessments?.sorted(by: {($0.dateUpdated ?? Date()).timeIntervalSince1970 > ($1.dateUpdated ?? Date()).timeIntervalSince1970}).filter{$0.reportData != nil} ?? []
    }
    
    func onAppear() {
        // MARK: - update 
        try? Assessment.resultController.performFetch()
    }
}

struct ReportRowView: View {
    @ObservedObject var viewModel: ReportRowViewModel
    var body: some View {
        HStack {
            ZStack {
                Button(action:{}) {
                    Image(uiImage: self.viewModel.pdfPreview)
                }
                ActivityIndicator(isAnimating: $viewModel.preparing, style: .medium, color: .tintColor)
            }
            Text(viewModel.caption)
        }.onAppear(perform: viewModel.onAppear)
    }
}

class ReportRowViewModel: ObservableObject {
    let assessment: Assessment
    var caption: String
    init(_ assessment: Assessment) {
        self.assessment = assessment
        caption = assessment.remarks
    }
    
    @Published var preparing = true
    @Published var pdfPreview = UIImage(named: "pdfPreview")!
    
    func onAppear() {
        if let image = preview(of: assessment.reportData!) {
            pdfPreview = image
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.preparing = false
            }
        }
    }
    
    func preview(of data: Data) -> UIImage? {
        guard let page = PDFDocument(data: data)?.page(at: 1) else {
            return nil
        }
        let thumnailSize = CGSize(width: 8.5 * 72, height: 11 * 72)

        return page.thumbnail(of: thumnailSize, for: .mediaBox)
    }
}
