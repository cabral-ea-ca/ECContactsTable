//
//  ViewController.swift
//  ECContactsTable
//
//  Created by Ryerson Student on 2018-07-03.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit

import UIKit
import Contacts

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    internal let contactStore = CNContactStore()
    internal var contactList  = [[HCContact]]()
    internal let letterIdx    = [ "FAV", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
                                  "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                                  "U", "V", "W", "X", "Y", "Z", "UKN" ]
    
    internal func retrieveContacts( contactStore: CNContactStore ){
        let containerID = contactStore.defaultContainerIdentifier()
        let predicate   = CNContact.predicateForContactsInContainer(withIdentifier: containerID)
        let keystoFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                           CNContactFamilyNameKey as CNKeyDescriptor,
                           CNContactOrganizationNameKey as CNKeyDescriptor,
                           CNContactImageDataKey as CNKeyDescriptor,
                           CNContactImageDataAvailableKey as CNKeyDescriptor]
        
        do {
            let rawContactList = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keystoFetch)
            for rawContactData in rawContactList{
                let contactData    = HCContact(contact: rawContactData)
                let contactDataIdx = contactData.startingLettertoIdx()+1
                contactList[contactDataIdx].append(contactData)
            }
            print( contactList )
        }
        catch {
            print( error )
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.leftBarButtonItem = editButtonItem

        for _ in 0..<letterIdx.count{
            let contactArray = [HCContact]()
            contactList.append(contactArray)
        }

        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            retrieveContacts( contactStore: contactStore )
            
        case .denied,
             .notDetermined,
             .restricted:
            contactStore.requestAccess(for: .contacts, completionHandler: requestAccessHandler)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
