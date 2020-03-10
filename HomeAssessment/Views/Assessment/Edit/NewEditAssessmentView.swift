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
//    var barTitle: String
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("备注")) {
                    CustomTextField("请输入备注，留空则为住宅地址",
                                    text: $viewModel.remarks,
                                    showClearButton: true,
                                    disabled: viewModel.saving,
                                    returnKeyType: .done,
                                    didBeginEditing: viewModel.didBeginEditingRemarks,
                                    didEndEditing: viewModel.didEndEditingRemarks)
                }
                
                ContactSectionView(viewModel: .init(assessment: viewModel.assessment))
                    .disabled(viewModel.editingRemarks || viewModel.saving)

                
                ElderSectionView(viewModel: .init(assessment: viewModel.assessment))
                    .disabled(viewModel.editingRemarks || viewModel.saving)

                
                Section(header: Text("选择标准")) {
                    Button(action:{
                        self.viewModel.searchStandardModal.toggle()
                    }) {
                        Text(self.viewModel.selectedStandard?.name ?? "点击选择")
                            .sheet(isPresented: $viewModel.searchStandardModal) {
                                StandardListView(
                                    viewModel: .init(user: .currentUser),
                                    selected: self.$viewModel.selectedStandard)
                                    .accentColor(.accentColor)
                                
                        }
                        
                    }
                }
                .disabled(viewModel.editingRemarks || viewModel.saving)
                
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
                .disabled(viewModel.editingRemarks || viewModel.saving)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("\(viewModel.barTitle)", displayMode: .inline)
            .navigationBarItems(
                leading:
                Button(action:{
                    self.viewModel.cancel()
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("取消")
                }.disabled(viewModel.saving),
                
                trailing: Button(action:{
                    self.viewModel.save() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }){
                    if viewModel.saving {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    } else {
                        Text("保存")
                    }
                    
                }.disabled(viewModel.doneButtonDisabled || viewModel.saving)
            )
            .navigationBarBackButtonHidden(true)
        }
    }
    
    
}


class NewEditAssessmentViewModel:NSObject, NSFetchedResultsControllerDelegate,  ObservableObject {
    
    @Published var searchStandardModal: Bool = false
    @Published var selectedStandard: Standard?
    @Published var remarks: String!
    @Published var presentingMap = false
    @Published var locatedAt: MKPlacemark?
    @Published var editingRemarks = false
    @Published var saving = false
    
    var contact: Contact? = nil
//    var id: UUID
    
    var assessment: Assessment
    init(assessment: Assessment) {
        print("initing NewEditAssessmentView")
        self.assessment = assessment
//        super.init()
        // MARK: - important?
        remarks = assessment.remarks
        selectedStandard = assessment.standard
        locatedAt = assessment.address == nil ? nil : MKPlacemark(placemark: assessment.address!)
//        Elder.resultController.delegate = self
//        Contact.resultController.delegate = self
    }
    
    
    var barTitle: String {
        saving
            ? "正在保存..."
            : (assessment.remarks.isEmpty
                ? "新建评估"
                : assessment.remarks)
    }
    
    var doneButtonDisabled: Bool {
        print("** done button", assessment)
        return assessment.getContacts().isEmpty // xie!!!!!!
            || assessment.getElders().isEmpty
            || selectedStandard == nil
            || locatedAt == nil
            || editingRemarks
    }
    
    
    func didBeginEditingRemarks() {
        self.editingRemarks = true
    }
    func didEndEditingRemarks() {
        self.editingRemarks = false
    }
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
//        if assessment.hasChanges {
//            print("** roll back onDisappear")
//            CoreDataHelper.stack.context.rollback()
//        }
        
    }
    func save(completionHandler: @escaping ()-> Void = {}) {
        print("** saving")
        if remarks.isEmpty {
            print("empty remakr")
            remarks = locatedAt?.name ?? "无备注"
        }
        assessment.update(remarks: remarks, address: locatedAt, progress: assessment.progress, standard: selectedStandard)
//        assessment.remarks = remarks
//        assessment.address = locatedAt
//        assessment.standard = selectedStandard
        
        saving = true
        CoreDataHelper.stack.save()
        print("** saved")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completionHandler()
        }
        
    }
    
}
