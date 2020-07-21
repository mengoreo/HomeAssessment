//
//  Map.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/28.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchMapView: UIViewControllerRepresentable {
    var handleTapOnMapCallout: (_ selected: MKAnnotation) -> Void
    @Binding var selectedPlace: MKPlacemark?
    init(selectedPlace: Binding<MKPlacemark?>,
         handleTapOnMapCallout: @escaping (_ selected: MKAnnotation) -> Void = {_ in }) {
        self._selectedPlace = selectedPlace
        self.handleTapOnMapCallout = handleTapOnMapCallout
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<SearchMapView>) -> UINavigationController {
        let spvc = SearchPlacesViewController(selectedPlace: selectedPlace, handleTapOnMapCallout: handleTapOnMapCallout)
        let nv = UINavigationController(rootViewController: spvc)
        
        return nv
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<SearchMapView>) {
        //
    }
}
