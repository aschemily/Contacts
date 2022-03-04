//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Emily Asch on 3/4/22.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //landing pad
    var contact: Contact?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatingFields()
    }
    
    //if updated set values in detail page
    func updatingFields(){
        if let contact = contact{
            nameTextField.text = contact.name
            numberTextField.text = contact.phone
            emailTextField.text = contact.email
        }else{
            return
        }
    }
    
    
    func goBack(){
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //make sure name text is not empty
        guard let name = nameTextField.text, !name.isEmpty else {return}
        let phone = numberTextField.text
        let email = emailTextField.text
        
        if let contact = contact{
            ContactController.shared.update(contact: contact, name: name, phone: phone ?? "", email: email ?? "") { success in
                if success{
                    self.goBack()
                }
            }
        }else{
            ContactController.shared.saveContact(with: name, email: email, phone: phone) { success in
                if success{
                    print("new contact saved")
                    self.goBack()
                }
            }
        }
    }
    

}//end of class
