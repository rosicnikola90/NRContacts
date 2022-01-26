//
//  ContactsViewModel.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import UIKit

protocol ContactsViewModelDelegate: class {
    func contactsUpdatedWitSuccess()
    func contactsUpdatedWithError(error: String)
}

final class ContactsViewModel: NSObject {
    
    //MARK: - properties
    weak var delegate: ContactsViewModelDelegate?
    private var contactList: [Result] = []
    
    //MARK: - init
    override init() {
        
    }
    
    deinit {
        print("ContactsViewModel deinit")
    }
    
    //MARK: - metods
    func getContacts() {
        DataManager.sharedInstance.getContacts { [weak self] (contacts, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.delegate?.contactsUpdatedWithError(error: error)
                } else if let contacts = contacts {
                    self.contactList = contacts
                    self.delegate?.contactsUpdatedWitSuccess()
                } else {
                    self.delegate?.contactsUpdatedWithError(error: error ?? "something went wrong")
                }
            }
        }
    }
    
}

// MARK: - extension tableViewDataSource
extension ContactsViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        return cell
    }
    
}
