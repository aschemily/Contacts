//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Emily Asch on 3/3/22.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    var refresh: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    //load data
    func loadData(){
        ContactController.shared.fetchContacts { success in
            if success{
                self.updateViews()
            }else{
                print("error")
            }
        }
    }

    func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = ContactController.shared.contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phone
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let contactToDelete = ContactController.shared.contacts[indexPath.row]
            guard let index = ContactController.shared.contacts.firstIndex(of: contactToDelete) else {return}
            
            ContactController.shared.delete(contactToDelete) { success in
                if success{
                    ContactController.shared.contacts.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        //identifier
        if segue.identifier == "toContactDetailVC",
         //index path and destination
          let indexPath = tableView.indexPathForSelectedRow,
          let destination = segue.destination as? ContactDetailViewController{
            //object to send
            let contactObject = ContactController.shared.contacts[indexPath.row]
            
            //object to receive
            destination.contact = contactObject
        
        }
      
    }


}//end of class
