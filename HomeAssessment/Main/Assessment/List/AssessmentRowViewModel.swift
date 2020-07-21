//
//  AssessmentRowViewModel.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import MapKit

class AssessmentRowViewModel: NSObject, ObservableObject {
    private let mapSnapshotOptions = MKMapSnapshotter.Options()
    var mapPreview: UIImage {
        assessment.mapPreview?.uiImage ?? .mapPreview
    }
    @Published var needUpdatePreview = false
    @Published var assessment: Assessment
    @Published var showMapModal = false
    
    @Published var showEditModel = false
    @Published var shareModal = false
    @Published var sharedItems = [AirDropData]()
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
        objectWillChange.send()
        if assessment.standard != nil {
            assessment.progress = Double(assessment.selectedOptions.count) / Double( assessment.standard!.getQuestions().count) * 100
            if assessment.dateUpdated!.distance(to: Date()) < 1 {
                aboutToShare()
            }
            print("progress", assessment.progress, "date", assessment.dateCreated, "just now?:", assessment.dateUpdated!.distance(to: Date()) < 1, assessment.dateUpdated!.distance(to: Date()))
        } else { assessment.progress = 0; assessment.selectedOptions.removeAll() }
        // MARK: - 重新检查是否需要更新预览图
        needUpdatePreview = assessment.mapPreviewNeedsUpdate
        if needUpdatePreview { updateMapPreview() }
        
    }
    func showMap() {
        showMapModal.toggle()
    }
    func updateMapPreview() {
        setupSnapshotOptions()
        takeSnapshot()
    }
    
    func aboutToShare() {
        do {
            try sharedItems.append(ShareDataManager.manager.compressAndShare(assessment))
            shareModal = true
        } catch {
            fatalError("** share failed: \(error)")
        }
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
        guard let center = assessment.address?.location?.coordinate else {
            print("*** center not correct")
            self.needUpdatePreview = false
            return
        }
        mapSnapshotOptions.region = MKCoordinateRegion(center: center, span: span)
        
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
                    print("saved")
                    self.needUpdatePreview = !saved
//                    self.mapPreview = self.assessment.mapPreview?.uiImage ?? .mapPreview
                    self.objectWillChange.send()
                }
                
                
            }
            
        }
    }
    
}
