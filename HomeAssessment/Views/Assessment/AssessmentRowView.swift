//
//  AssessmentRowView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/29.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import MapKit

struct CurrentLocationView: UIViewRepresentable {
    var placemark: CLPlacemark
    
    func makeUIView(context: UIViewRepresentableContext<CurrentLocationView>) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        
        return mapView
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<CurrentLocationView>) {
        print("** updateUIView")
        dropAnnotation(at: placemark, in: uiView)
        
        uiView.showsUserLocation = false
        uiView.showsScale = true
        uiView.showsCompass = true
        uiView.showsTraffic = true
        uiView.showsBuildings = true
    }
    
    private func dropAnnotation(at placemark: CLPlacemark, in mapView: MKMapView) {
//        mapView.removeAnnotations(mapView.annotations)
        let annotation = CustomAnnotation(placemark: MKPlacemark(placemark: placemark))
        annotation.title = placemark.name
        annotation.subtitle = placemark.address()
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        print("** dropped")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            print("** an:", annotation)
            guard !annotation.isKind(of: MKUserLocation.self) else {
                // customize in didselect .
                return nil
            }
            
            let view = setupCustomPinCallout(for: annotation)
            return view
        }
        private func setupCustomPinCallout(for annotation: MKAnnotation) -> MKAnnotationView {
            
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.markerTintColor = .tintColor
            annotationView.canShowCallout = true
            
            let detailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 23))
            detailLabel.text = annotation.subtitle ?? ""
            detailLabel.lineBreakMode = .byWordWrapping
            detailLabel.numberOfLines = 0
            detailLabel.font = .preferredFont(forTextStyle: .footnote)
            detailLabel.textColor = .secondaryLabel
            annotationView.detailCalloutAccessoryView = detailLabel
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            rightButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .highlighted)
            rightButton.tintColor = .tintColor

            annotationView.rightCalloutAccessoryView = rightButton
            return annotationView
        }

    }
    
}
struct AssessmentRowView: View {
    @ObservedObject var viewModel: AssessmentRowViewModel
    @State var showImage = false
    var body: some View {
                    
        HStack(alignment: .center) {
            
            ZStack {
                Button(action: {
                    self.showImage.toggle()
                    self.viewModel.showMap()
                }) {
                    ZStack {
                        Image(uiImage: self.viewModel.assessment.mapPreview ?? .mapPreview).resizable()
                        ActivityIndicator(isAnimating: $viewModel.assessment.mapPreviewNeedsUpdate, style: .medium, animationStarted: viewModel.updateMapPreview)
                    }
                }
                .buttonStyle(ImageButtonStyle(width: 50, height: 50))
                
                Text("").hidden().sheet(isPresented: $showImage) {
                    NavigationView {
                        CurrentLocationView(placemark: self.viewModel.assessment.address!)
                            .edgesIgnoringSafeArea(.all)
                            .navigationBarTitle("\(self.viewModel.assessment.remarks)",
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
                }
                
            }
            Spacer()
            
            VStack(alignment: .center, spacing: 1) {
                HStack(spacing: 3) {
                    Text(viewModel.assessment.dateString.split(separator: " ").joined(separator: "\n"))
                        .font(.system(size: 10))
                    Image(systemName: "chevron.right").imageScale(.small)
                }
                .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
        }
        .padding(.vertical, 3)
        .frame(height: 70)
        
    }
}

class AssessmentRowViewModel: ObservableObject {
    private let mapSnapshotOptions = MKMapSnapshotter.Options()
    private var updatingImage = false
    var assessment: Assessment
    
    init(assessment: Assessment) {
        self.assessment = assessment
    }
    
    
    func editModalDismissed() {
        CoreDataHelper.stack.context.rollback()
    }
    func updateMapPreview() {
        self.setupSnapshotOptions()
        self.takeSnapshot()
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
        
        if assessment.mapPreviewNeedsUpdate {
            snapShotter.start { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print(error ?? "Unknown error")
                    return
                }
                guard self.assessment.mapPreviewNeedsUpdate else {
                    print("*** already updated image")
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

                
                self.assessment.update(preview: compositeImage)
                CoreDataHelper.stack.save()
            }
        }
    }
    
    func showMap() {
        
    }
    
    func doneShowMap() {
//        updateMapPreview()
//        updateMapPreview()
    }
}
