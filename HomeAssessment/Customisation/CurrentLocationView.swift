//
//  CurrentLocationView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/10.
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
