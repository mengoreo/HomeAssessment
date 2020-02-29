//
//  NewEditAssessmentView.swift
//  tet
//
//  Created by Mengoreo on 2020/2/23.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData
import MapKit

struct NewEditAssessmentView: View {
    
    @ObservedObject var viewModel: NewEditAssessmentViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var barTitle: String
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("备注")) {
                    CustomTextField("请输入备注，留空则为住宅地址", text: $viewModel.remarks, showClearButton: true, returnKeyType: .done, didBeginEditing: viewModel.didBeginEditingRemarks, didEndEditing: viewModel.didEndEditingRemarks )
                }
                
                ContactSectionView(viewModel: .init(assessment: viewModel.assessment))
                    .disabled(viewModel.editingRemarks)

                
                ElderSectionView(viewModel: .init(assessment: viewModel.assessment))
                    .disabled(viewModel.editingRemarks)

                
                Section(header: Text("选择标准")) {
                    Button(action:{
                        self.viewModel.searchStandardModal.toggle()
                    }) {
                        Text(self.viewModel.assessment.standard?.name ?? "点击选择")
                            .sheet(isPresented: $viewModel.searchStandardModal) {
                                StandardListView(
                                    viewModel: .init(user: .currentUser),
                                    selected: self.$viewModel.assessment.standard)
                                    .accentColor(.accentColor)
                                
                        }
                        
                    }
                }
                .disabled(viewModel.editingRemarks)
                
                Section(header: Text("住宅地址")) {
                    Button(action:{
                        self.viewModel.presentingMap.toggle()
                    }) {
                        Text("\((viewModel.locatedAt?.address() ?? "点击搜索位置"))")
                    }
                        .sheet(isPresented: $viewModel.presentingMap) {
                            SearchMapView(selectedPlace: self.$viewModel.locatedAt,
                                          handleTapOnMapCallout: self.viewModel.didSelect(_:))
                                .edgesIgnoringSafeArea(.all)
                    }
                }
                .disabled(viewModel.editingRemarks)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("\(barTitle)", displayMode: .inline)
            .navigationBarItems(
            leading:
            Button(action:{
                self.viewModel.cancel()
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("取消")
            },
            trailing: Button(action:{
                self.viewModel.save()
                self.presentationMode.wrappedValue.dismiss()
            }){Text("保存")}.disabled(viewModel.doneButtonDisabled))
            .navigationBarBackButtonHidden(true)
        }
    }
    
    
}


class NewEditAssessmentViewModel: ObservableObject {
    
    @Published var searchStandardModal: Bool = false
    @Published var selectedStandard: Standard? = nil {
       didSet {
            if oldValue != selectedStandard {
//                selectedStandardDidChange()
            }
        }
    }
    @Published var remarks: String
    @Published var presentingMap = false
    @Published var locatedAt: MKPlacemark? {
        didSet {
            if oldValue != locatedAt {
//                locatedAtDidChange()
            }
        }
    }
    @Published var editingRemarks = false
    

    var assessment: Assessment
    var contact: Contact? = nil
    
    init(assessment: Assessment) {
        self.assessment = assessment
        remarks = assessment.remarks
        selectedStandard = assessment.standard
        locatedAt = assessment.address == nil ? nil : MKPlacemark(placemark: assessment.address!)
    }
    
    var doneButtonDisabled: Bool {
        print("** done button", assessment)
        return assessment.getContacts().isEmpty
            || assessment.getElders().isEmpty
            || selectedStandard == nil
            || locatedAt == nil
//            || !assessment.hasChanges
    }
    
    
//    func remarksDidChange() {
//        assessment.update(remarks: remarks)
//        remarks = assessment.remarks
//    }
    func didBeginEditingRemarks() {
        self.editingRemarks = true
    }
    func didEndEditingRemarks() {
        self.editingRemarks = false
//        remarksDidChange()
    }
//    func locatedAtDidChange() {
//        assessment.update(address: locatedAt)
//    }
//    func selectedStandardDidChange() {
//        print("** selectedStandardDidChange")
//        assessment.update(standard: selectedStandard)
//        selectedStandard = assessment.standard
//    }
    func didSelect(_ place: MKAnnotation) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)) {placemarks, error in
            guard error == nil else {
                print("** userLocation reverse geo error: \(error!)")
                return
            }
            // Most geocoding requests contain only one result.
            if let firstPlacemark = placemarks?.first {
                self.locatedAt = MKPlacemark(placemark: firstPlacemark)
            }
        }
    }
    
    func cancel() {
        if assessment.hasChanges {
            print("** roll back onDisappear")
            CoreDataHelper.stack.context.rollback()
        }
    }
    func save() {
        if remarks.isEmpty {
            print("empty remakr")
            remarks = locatedAt?.name ?? "无备注\(assessment.dateString)"
        }
        assessment.update(remarks: remarks, address: locatedAt, progress: assessment.progress, standard: selectedStandard)
        assessment.dateUpdated = Date()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // save after dismiss the modal
            CoreDataHelper.stack.save() // then disappear
//        }
    }
    
}
