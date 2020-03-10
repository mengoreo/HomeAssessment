//
//  ContactSectionView.swift
//  tet
//
//  Created by Mengoreo on 2020/2/24.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import CoreData

struct ContactSectionView: View {
    @ObservedObject var viewModel: ContactSectionViewModel
    
    var body: some View {
        Group { // for on appear to work
            Section(header:Text("联系人（儿女最佳）")) {
                
                ForEach(viewModel.contacts) { contact in
                    NavigationLink(
                    destination: NewEditContactView(viewModel: .init(assessment: self.viewModel.assessment, contact: contact))) {
                            Text(contact.name)
                                .contextMenu {
                                    Button(action:{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                            contact.delete()
                                        }
                                    }) {
                                        Text("删除")
                                        Image(systemName: "trash.circle")
                                    }
                                }
                            
                    }
                }.onDelete(perform: viewModel.delete(at:))
                
                
                NavigationLink(destination: NewEditContactView(viewModel: .init(assessment: self.viewModel.assessment))) {
                    Button(action:{}){
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("添加联系人")
                                .accentColor(Color(UIColor.label))
                        }
                    }
                }
            }.onAppear(perform: viewModel.onAppear)
        }
    }
}

class ContactSectionViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    let assessment: Assessment
//    let context: NSManagedObjectContext
    // manually publish changes
    var contacts: [Contact] {
        assessment.getContacts()
//        Contact.all()
//        return Contact.all()
        
    }
    
    init(assessment: Assessment) {
        self.assessment = assessment
    }
    
//    private lazy var contactController: NSFetchedResultsController<Contact> = {
//        let ct = Contact.resultController
//        ct.delegate = self
//        return ct
//    }()
    
    func onAppear() {
        print("contact section appear")
        objectWillChange.send()
    }
    
    func delete(at offsets: IndexSet) {
        objectWillChange.send()
        for index in offsets {
//            contacts[index].delete()
            assessment.managedObjectContext?.delete(contacts[index])
        }
    }
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        print("contact will change")
//        objectWillChange.send()
//    }
}