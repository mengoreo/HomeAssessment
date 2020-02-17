//
//  TestList.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/14.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI

struct TestList: View {
    @State private var users = ["Paul", "Taylor", "Adele"]

    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.self) { user in
                    Text(user)
                }
                .onMove(perform: move)
            }
            .navigationBarItems(trailing: EditButton())
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
}

struct TestList_Previews: PreviewProvider {
    static var previews: some View {
        TestList()
    }
}
