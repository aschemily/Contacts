//
//  Contact.swift
//  Contacts
//
//  Created by Emily Asch on 3/3/22.
//

import CloudKit

struct ContactStrings{
    static let contactKey = "Contact"
    fileprivate static let nameKey = "name"
    fileprivate static let emailKey = "email"
    fileprivate static let phoneKey = "phone"
//    fileprivate static let userReferenceKey = "userReference"
}

class Contact {
    //class properties
    var name: String
    var phone: String?
    var email: String?
    
    
    //cloudkit properties
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference?
    
    init(name: String, phone: String? = nil, email: String? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.name = name
        self.email = email
        self.phone = phone
        self.recordID = recordID
    }
}

//retrieving ck record
extension Contact{
    convenience init?(ckRecord: CKRecord){
        guard let name = ckRecord[ContactStrings.nameKey] as? String,
              let phone = ckRecord[ContactStrings.phoneKey] as? String,
              let email = ckRecord[ContactStrings.emailKey] as? String
              
                    else {return nil}
        
     //   let userReference = ckRecord[ContactStrings.userReferenceKey] as? CKRecord.Reference
        
        self.init(name: name, phone: phone, email: email, recordID: ckRecord.recordID)
    }
}

//equatable to delete contact
extension Contact: Equatable{
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

//turning object in ckrecord
extension CKRecord{
    convenience init(contact: Contact){
        self.init(recordType: ContactStrings.contactKey, recordID: contact.recordID)
        
        self.setValuesForKeys([
            ContactStrings.nameKey : contact.name,
            ContactStrings.phoneKey : contact.phone,
            ContactStrings.emailKey : contact.email
            
        ])
        
        
    }
}
