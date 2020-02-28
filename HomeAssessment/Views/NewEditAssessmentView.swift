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
                    CustomTextField("请输入备注，留空则为住宅地址", text: $viewModel.remarks, isEditing: $viewModel.editingRemarks, showClearButton: true, returnKeyType: .done)
                }
                
                ContactSectionView(viewModel: .init(assessment: viewModel.assessment))
                    .disabled(viewModel.editingRemarks)

                
                ElderSectionView(viewModel: .init(assessment: viewModel.assessment))
                    .disabled(viewModel.editingRemarks)

                
                Section(header: Text("选择标准")) {
                    Button(action:{
                        self.viewModel.searchStandardModal.toggle()
                    }) {
                        Text(self.viewModel.selectedStandard?.name ?? "点击选择")
                            .sheet(isPresented: $viewModel.searchStandardModal) {
                                StandardListView(
                                    viewModel: .init(user: .currentUser),
                                    selected: self.$viewModel.selectedStandard)
                                    .accentColor(.darkGreen)
                                
                        }
                        
                    }
                }
                .disabled(viewModel.editingRemarks)
                
                Section(header: Text("住宅地址")) {
                    Button(action:{
                        self.viewModel.presentingMap.toggle()
                    }) {
                        Text("\((viewModel.locatedAt?.name ?? "点击搜索位置"))")
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
            selectedStandardDidChange()
        }
    }
    @Published var remarks: String {
        didSet {
            remarksDidChange()
        }
    }
    @Published var presentingMap = false
    @Published var locatedAt: MKPlacemark? {
        didSet {
            locatedAtDidChange()
        }
    }
    @Published var editingRemarks = false
    

    let assessment: Assessment
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
            || assessment.standard == nil
            || assessment.address == nil
            || !assessment.hasChanges
    }
    
    
    func remarksDidChange() {
        assessment.update(remarks: remarks)
    }
    func locatedAtDidChange() {
        print("** locatedAtDidChange")
        assessment.update(address: locatedAt)
    }
    func selectedStandardDidChange() {
        print("** selectedStandardDidChange")
        assessment.update(standard: selectedStandard)
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
                self.assessment.update(address: self.locatedAt)
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
            remarks = locatedAt?.address() ?? "无备注"
        }
        assessment.update(remarks: remarks, address: locatedAt, progress: assessment.progress, standard: selectedStandard)
        assessment.dateUpdated = Date()
        CoreDataHelper.stack.save() // then disappear
    }
    
}
