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
        //initilize new contact
        let newContact = Contact(name: name, phone: phone, email: email)
        //package new contact in a ckrecord
        let contactRecord = CKRecord(contact: newContact)
        //save it to the cloud
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
    func fetchContacts(completion: @escaping (Bool)->Void){
        //step 3 init predicate
        let predicate = NSPredicate(value: true)
        //step 2 init the requisite query for the .perform method
        let query = CKQuery(recordType: ContactStrings.contactKey, predicate: predicate)
        
        //step 1 perform query on database
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("🔴error in \(#function), \(error.localizedDescription), \(error)🔴")
                completion(false)
                return
            }
            //unwrap the records
            guard let records = records else {completion(false) ; return}
            print("⭐️fetched all contacts \(records)⭐️")

            //compact map through the found records to return the non-nil contact objects
            let fetchedContacts = records.compactMap { Contact(ckRecord: $0)}
            //set source of truth
            self.contacts = fetchedContacts
            completion(true)
        }
        
    }
    
    //update
    func update(contact: Contact, name: String, phone: String, email: String, completion: @escaping(Bool)->Void){
        contact.name = name
        contact.phone = phone
        contact.email = email
        //step 3 grab record to update
        let recordToUpdate = CKRecord(contact: contact)
        
        //step 2 create requisite operation
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate])
        
        //step 4 set properties for the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {records, _, error in
            //handle error
            if let error = error{
                print("🔴error in \(#function), \(error.localizedDescription), \(error)🔴")
                completion(false)
                return
            }
            //make sure records were returned and updated
            guard let record = records?.first else{
                completion(false)
                return
            }
            //return completion true
            print("✅updated \(record) successfully to cloudkit✅")
            completion(true)
            
        }
        
        //step 1 add operation to db
        publicDB.add(operation)
    }
    
    //delete
    func delete(_ contact: Contact, completion: @escaping(Bool)->Void){
       
        //step 2 create operation and since we already have contact we can grab the recordID
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [contact.recordID])
        
        //step 3 set properties to operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {_, recordIDs, error in
            //handle error
            if let error = error{
                print("🔴error in \(#function), \(error.localizedDescription), \(error)🔴")
                completion(false)
                return
            }
            //unwrapping recordID to delete
            guard let recordIDs = recordIDs else {
                completion(false)
                return
            }
            print("\(recordIDs) removed successfully🎉")
           completion(true)
        }
        
        //step 1 add operation to database
        publicDB.add(operation)
    }

}//end of class
