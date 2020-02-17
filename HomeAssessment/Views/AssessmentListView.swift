//
//  AssessmentListView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/11.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct AssessmentListView: View {
    @State var animated = false
    var rowHeight = Device.width / 5
    let names = ["Raju", "Ghanshyam", "Baburao Ganpatrao Apte", "Anuradha", "Kabira", "Chaman Jhinga", "Devi Prasad", "Khadak Singh"]
    
    @State private var searchTerm : String = ""
    @State private var currentSection = 0
    private var section = ["概览", "报告"]
    @State private var adding = false
    
    var body: some View {
        SearchModalView("搜索", searchedText: $searchTerm, barTitle: "我的评估", preferLargeTitle: true, scopes: section) { result in
            Text("hello \(result)")
        }.edgesIgnoringSafeArea(.all)
//        NavigationView {
//            VStack {
//                Spacer()
//                Picker("Numbers", selection: $currentSection) {
//                    ForEach(0 ..< section.count) { index in
//                        Text(self.section[index]).tag(index)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//
//
//
//                List {
////                    SearchBar(text: $searchTerm)
//
//                    NavigationLink(destination: SignInView(viewModel: .init(from: .init()))) {
//                        HStack(alignment: .center) {
//                            Button(action:{
//                                print("** add row")
//                            }){
//                                Image.mapPreviewLight.resizable()
//                            }
//                            .buttonStyle(ImageButtonStyle(width: rowHeight, height: rowHeight))
//                            .padding(.bottom, 5)
//
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text("万亭花园").font(.headline)
//                                Text("评估进度：33%").font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }.alignmentGuide(VerticalAlignment.center
//                                , computeValue: {_ in 27})
//                            Spacer()
//                            Text("9:31")
//                            .foregroundColor(.secondary)
//                        }
//                        }.buttonStyle(PlainButtonStyle())
//
//                    NavigationLink(destination: SignInView(viewModel: .init(from: .init()))) {
//                        HStack(alignment: .center) {
//                            Button(action:{
//                                print("** add row")
//                            }){
//                                Image.mapPreviewLight.resizable()
//                            }
//                            .buttonStyle(ImageButtonStyle(width: rowHeight, height: rowHeight))
//                            .padding(.bottom, 5)
//
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text("万亭花园").font(.headline)
//                                Text("评估进度：33%").font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }.alignmentGuide(VerticalAlignment.center
//                                , computeValue: {_ in 27})
//                            Spacer()
//                            Text("9:31")
//                            .foregroundColor(.secondary)
//                        }
//                    }.buttonStyle(PlainButtonStyle())
//                }
//            }.sheet(isPresented: $adding) {
//                NewAssessmentView()
//            }
//            .navigationBarTitle("我的评估", displayMode: .large)
//            .navigationBarItems(
//                leading: Image.icon.resizable().frame(width: 20, height: 20, alignment: .center),
//                trailing:
//                    Button(action:{
//                        self.adding.toggle()
//                    }){
//                        Image(systemName: "plus").accentColor(Color("DarkGreen"))
//                    }
//                )
//                .background(NavigationConfigurator{nc in
//                    nc.navigationItem.searchController = UISearchController(searchResultsController: nil)
//                    nc.navigationItem.hidesSearchBarWhenScrolling = true
//                })
//        }
//        .accentColor(Color("DarkGreen"))
    }
}

struct AssessmentListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE"], id: \.self) { deviceName in
            AssessmentListView()
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
