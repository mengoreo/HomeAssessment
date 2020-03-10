//
//  NewEditContactView.swift
//  tet
//
//  Created by Mengoreo on 2020/2/24.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData

struct NewEditContactView: View {
    @ObservedObject var viewModel: NewEditContactViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Group {
            List {
                Section {
                    TextField("姓名", text: $viewModel.contactName)
                    TextField("联系电话", text: $viewModel.contactPhone)
                }
                
            }.gesture(DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            
        }
            
        .navigationBarTitle("\(viewModel.barTitle)", displayMode: .inline)
        .navigationBarItems(trailing: Button(action:{
                self.viewModel.save()
                self.presentationMode.wrappedValue.dismiss()
            }){Text("完成")}.disabled(viewModel.doneButtonDisabled))
        
    }
    
}


class NewEditContactViewModel: ObservableObject {
    @Published var contactName: String
    @Published var contactPhone: String
    
    private var assessment: Assessment
    var contact: Contact?
    init(assessment: Assessment, contact: Contact? = nil) {
        self.assessment = assessment
        self.contact = contact
        contactName = contact?.name ?? "fake"
        contactPhone = contact?.phone ?? "177"
    }
    
    var doneButtonDisabled: Bool {
        return contactName.isEmpty || contactPhone.isEmpty
    }
    lazy var barTitle: String = {
        return contactName.isEmpty ? "新建联系人" : contactName
    }()
    
    func save() {
        if let contact = contact {
            contact.update(name: contactName, phone: contactPhone)
        }else {
            print("add to contacts")
//            Contact.create(for: assessment, name: contactName, phone: contactPhone)
            let c = Contact.create(for: assessment, name: contactName, phone: contactPhone, in: assessment.managedObjectContext)
//            try? context.save()
//           let c = Contact.create(name: contactName, phone: contactPhone)
//            c.setPrimitiveValue(assessment, forKey: "assessment")// MARK: - important!!! for not notify changes
        }
    }
}
