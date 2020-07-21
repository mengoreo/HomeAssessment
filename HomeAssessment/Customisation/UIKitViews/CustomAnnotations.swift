//
//  CustomAnnotations.swift
//  tet
//
//  Created by Mengoreo on 2020/2/26.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    @objc dynamic var placemark: MKPlacemark
    
    var title: String?
    
    var subtitle: String?
    init(placemark: MKPlacemark, biased: Bool = false) {
        if biased {
            self.coordinate = CLLocationCoordinate2D(latitude: placemark.coordinate.latitude + 0.00015, longitude: placemark.coordinate.longitude + 0.00015)
        } else {
            self.coordinate = placemark.coordinate
        }
        self.placemark = placemark
        super.init()
    }
}
