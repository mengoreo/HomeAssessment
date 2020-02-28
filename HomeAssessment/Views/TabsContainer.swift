//
//  TabsContainer.swift
//  tet
//
//  Created by Mengoreo on 2020/2/23.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import MapKit

struct TabsContainer: View {
    @State var selected: MKPlacemark?
    @State var showing = false
    
    var body: some View {
        TabView {            
            AssessmentListView(viewModel: .init())
                .tag(0)
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Assessments")
                }
            
            StandardListView(viewModel: .init(user: .currentUser), selected: .constant(nil))
                .tag(1)
                .tabItem {
                    Image(systemName: "square.stack.3d.up.fill")
                    Text("Standards")
                }
            
        }
            .accentColor(.accentColor)
            .edgesIgnoringSafeArea(.top)

    }
    func address(from placemark: MKPlacemark?) -> String {
        
        
        if let placemark = placemark {
            var line1 = placemark.administrativeArea ?? ""

            line1 += placemark.subAdministrativeArea ?? ""
            line1 += placemark.locality ?? ""
            line1 += placemark.subLocality ?? ""
            line1 += placemark.thoroughfare ?? ""
            line1 += placemark.subThoroughfare ?? ""
            return line1
        }
        return "没找到诶"
    }
}

struct TabsContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabsContainer()
    }
}
