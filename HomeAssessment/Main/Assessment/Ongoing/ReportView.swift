//
//  ReportView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/13.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

class ReportViewModel: ObservableObject {
    let title: String
    let employees: [String]
    let elderCondition: String
    let houseCondition: String
    let problems: [String]
    let assessment: Assessment
    init(assessment: Assessment,
        title: String = "",
         employees: [String] = [],
         elderCondition: String = "",
         houseCondition: String = "",
         problems: [String] = []) {
        self.assessment = assessment
        self.title = title
        self.employees = employees
        self.elderCondition = elderCondition
        self.houseCondition = houseCondition
        self.problems = problems
        self.data = assessment.reportData
        print("init")
    }
    
    @Published var preparingData = true
    @Published var willShare = false
    @Published var preparingShare = false
    var data: Data!
    var airDropData: AirDropData!
    
    // MARK: - ReportViewModel
    func prepareData(){
        if self.data != nil {
            self.preparingData = false
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let pdfCreator = PDFCreator(title: self.title, authors: self.employees, elderCondition: self.elderCondition, houseCondition: self.houseCondition, problems: self.problems)
            self.data =  pdfCreator.prepareData()
            self.preparingData = false
        }
    }
    func share() {
        preparingShare = true
        airDropData = AirDropData(with: data, placeholder: "\(title)", type: .pdf)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.preparingShare = false
            self.willShare = true
        }
    }
    func save() {
        assessment.reportData = data
        assessment.progress = -1
        NotificationCenter.default.post(name: .DoneCombineAssessments, object: nil)
    }
    
}
struct ReportView: View {
    @ObservedObject var viewModel: ReportViewModel
    var body: some View {
        
            Group {
                if !viewModel.preparingData {
                    PDFPreviewView(data: viewModel.data)
                        .modifier(Toolbar(done: self.viewModel.share))
                } else {
                    VStack {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                        Text("正在生成报告...")
                    }
                }
            }.sheet(isPresented: $viewModel.willShare) {
                AirDropShareView(items: [self.viewModel.airDropData])
                    .edgesIgnoringSafeArea(.all)
            }
        
        .onAppear(perform: viewModel.prepareData)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(viewModel.preparingData)
            .navigationBarItems(trailing:
                ZStack {
                    ActivityIndicator(isAnimating: $viewModel.preparingShare, style: .medium)
                    Button("完成") {
                        self.viewModel.save()
                    }.opacity(self.viewModel.preparingShare ? 0 : 1)
                    
                }
            ).disabled(self.viewModel.preparingShare)
    }
}

