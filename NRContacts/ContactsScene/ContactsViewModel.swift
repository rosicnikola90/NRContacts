//
//  ContactsViewModel.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import UIKit

//protocol ListViewModelDelegate: class {
//    func symbolsUpdatedWitSuccess()
//    func symbolsUpdatedWithError(error: String)
//}

final class ContactsViewModel: NSObject {
    
    //MARK: - properties
    //private let contactList
    
    //MARK: - init
    override init() {
        
    }
    
    deinit {
        print("ContactsViewModel deinit")
    }
    
    //MARK: - metods

    
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
