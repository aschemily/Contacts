//
//  ContactController.swift
//  Contacts
//
//  Created by Emily Asch on 3/3/22.
//

import Foundation
import CloudKit

class ContactController{
    //shared instance
    static let shared = ContactController()
    
    //Source of truth
    var contacts: [Contact] = []
    
    //database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: CRUD
    
    //save/create
    func saveContact(with name: String, email: String?, phone: String?, completion: @escaping(Bool) -> Void){
        let newContact = Contact(name: name, email: email, phone: phone)
        let contactRecord = CKRecord(contact: newContact)
        
        publicDB.save(contactRecord) { record, error in
            if let error = error{
                print("🔴error in \(#function), \(error.localizedDescription), \(error)🔴")
                completion(false)
                return
            }
            guard let record = record,
                  let saveRecord = Contact(ckRecord: record) else{
                      completion(false)
                      return
                  }
            //append to array if successful
            self.contacts.append(saveRecord)
            completion(true)
        }
    }

    //fetch
    func fetchContacts(completion: (Bool)->Void){
        
    }
    
    //update
    
    //delete
 
    
}//end of class
