//
//  AssessmentRowView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/29.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import MapKit



struct AssessmentRowView: View {
    @ObservedObject var viewModel: AssessmentRowViewModel
    var body: some View {
                    
        HStack(alignment: .center) {
            
            ZStack {
                Button(action:viewModel.showMap) {
                    ZStack {
                        Image(uiImage: self.viewModel.mapPreview).resizable()
                        ActivityIndicator(isAnimating: $viewModel.needUpdatePreview, style: .medium, color: .tintColor)
                    }
                }
                .buttonStyle(ImageButtonStyle(width: 50, height: 50))
                
                Text("").hidden().sheet(isPresented: $viewModel.showMapModal) {
                    NavigationView {
                        CurrentLocationView(placemark: self.viewModel.assessment.address!)
                            .edgesIgnoringSafeArea(.all) .navigationBarTitle("\(self.viewModel.assessment.remarks)",
                                displayMode: .inline)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 7) {
                
                Text(viewModel.assessment.remarks)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("评估进度: \(String(format: "%.2f", viewModel.assessment.progress))%")
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    
                    if viewModel.assessment.standard == nil {
                        Text("<因评估标准删除而被重置>")
                            .font(.system(size: 10))
                            .foregroundColor(Color(UIColor.systemRed))
                            .bold()
                    }
                    Text("isfalulted: \(String(viewModel.assessment.isDeleted))")
                }
                
            }
            Spacer()
            
            VStack(alignment: .center, spacing: 1) {
                HStack(spacing: 3) {
                    Text((viewModel
                        .assessment
                        .dateUpdated ?? Date())
                        .dateString
                        .split(separator: " ")
                        .joined(separator: "\n")
                    ).font(.system(size: 10))
                }
                .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            Text("").hidden().sheet(isPresented: $viewModel.showEditModel, onDismiss: viewModel.editModalWillDismiss) {
                NewEditAssessmentView(viewModel: .init(assessment: self.viewModel.assessment))
                    .accentColor(.accentColor)
            }
            
            Text("").hidden().actionSheet(isPresented: $viewModel.showWarning) {
                ActionSheet(title: Text("\(self.viewModel.warningMessage)"), message: nil, buttons: [.cancel(Text("取消")), .destructive(Text("确定"), action: self.viewModel.warningDestructiveAction)])
            }
            
        }
        .contextMenu {
            Button(action: {
//                CoreDataHelper.stack.save()
                self.viewModel.showEditModel = true
            }) {
                Text("编辑")
                Image(systemName: "chevron.right.circle")
            }
            Button(action: {
                self.viewModel.aboutToDelete()
            }) {
                Text("删除❗️")
                Image(systemName: "trash.circle")
            }
        }
        
        .padding(.vertical, 3)
        .frame(height: 70)
        .onAppear(perform: viewModel.onAppear)
        
    }
}


class AssessmentRowViewModel: NSObject, ObservableObject {
    private let mapSnapshotOptions = MKMapSnapshotter.Options()
    var mapPreview: UIImage {
        assessment.mapPreview?.uiImage ?? .mapPreview
    }
    @Published var needUpdatePreview = false
    @Published var assessment: Assessment
    @Published var showMapModal = false
    
    @Published var showEditModel = false
    @Published var showWarning = false
    @Published var warningMessage = ""
    @Published var warningDestructiveAction: () -> Void = {}
    
    init(assessment: Assessment) {
        self.assessment = assessment
        needUpdatePreview = assessment.mapPreviewNeedsUpdate
        super.init() // required for update image after change style
        objectWillChange.send()
        if needUpdatePreview && !assessment.isValid() {
            print("will update preview in assrow")
            updateMapPreview()
        }
    }
    
    func onAppear() {
        
        print("objectWillChange in assrow\(DispatchTime.now().rawValue)")
        objectWillChange.send()
        if assessment.standard != nil {
            assessment.progress = Double(assessment.selectedOptions.count) / Double( assessment.standard!.getQuestions().count) * 100
            print("progress", assessment.progress)
        } else {
            assessment.progress = 0
            assessment.selectedOptions.removeAll()
        }
        
//         说
//        mapPreview = assessment.mapPreview?.uiImage ?? .mapPreview
        needUpdatePreview = assessment.mapPreviewNeedsUpdate
        if needUpdatePreview {
            updateMapPreview()
        }
        
    }
    func showMap() {
        showMapModal.toggle()
    }
    func updateMapPreview() {
        setupSnapshotOptions()
        takeSnapshot()
    }
    func aboutToDelete() {
        warningMessage = "该操作无法撤销！\n确定删除「\(assessment.remarks)」吗？"
        warningDestructiveAction = {
            CoreDataHelper.stack.delete(self.assessment)
        }
        showWarning = true
    }
    func editModalWillDismiss() {
        print("** editModalWillDismiss")
        CoreDataHelper.stack.context.rollback()
        needUpdatePreview = assessment.mapPreviewNeedsUpdate // update status required!!!!
        if needUpdatePreview && assessment.address != nil {
            updateMapPreview()
        }
    }
    // MARK: - setup snapshot
    private func setupSnapshotOptions() {
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = UIScreen.main.bounds.size
        mapSnapshotOptions.showsBuildings = true
    }
    
    // MARK: - take snapshot
    private func takeSnapshot() {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        mapSnapshotOptions.region = MKCoordinateRegion(center: assessment.address!.location!.coordinate, span: span)
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            let pin: UIImage = .placemark
            pin.withTintColor(.tintColor, renderingMode: .alwaysTemplate)
            let image = snapshot.image
            UIGraphicsBeginImageContextWithOptions(self.mapSnapshotOptions.size, true, image.scale)
            image.draw(at: CGPoint.zero)

            let visibleRect = CGRect(origin: CGPoint.zero, size: image.size)
            var point = snapshot.point(for: self.assessment.address!.location!.coordinate)
            print("** point", point)
            if visibleRect.contains(point) {
                point.x = point.x - (pin.size.width / 2)
                point.y = point.y - (pin.size.height)
                pin.draw(at: point)
            }

            let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            // required for updating preview
            self.assessment.update(preview: compositeImage) { saved in
                DispatchQueue.main.async {
                    self.needUpdatePreview = !saved
//                    self.mapPreview = self.assessment.mapPreview?.uiImage ?? .mapPreview
                    self.objectWillChange.send()
                }
                
                
            }
            
        }
    }
    
}
