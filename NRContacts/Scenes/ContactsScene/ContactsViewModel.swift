//
//  ContactsViewModel.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import UIKit

protocol ContactsViewModelDelegate: class {
    func didStartUpdatingContacts()
    func contactsUpdatedWitSuccess(forIndexPaths indexPats: [IndexPath])
    func contactsUpdatedWithError(error: String)
}

final class ContactsViewModel: NSObject {
    
    //MARK: - properties
    weak var delegate: ContactsViewModelDelegate?
    private var contactList: [Contact] = []
    private var startingIndexRow = 0
    private var indexPathsForUpdate: [IndexPath] = []
    
    //MARK: - init
    override init() {
        
    }
    
    deinit {
        print("ContactsViewModel deinit")
    }
    
    //MARK: - metods
    func getContacts() {
        delegate?.didStartUpdatingContacts()
        DataManager.sharedInstance.getContacts { [weak self] (contacts, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.delegate?.contactsUpdatedWithError(error: error)
                } else if let contacts = contacts {
                    self.contactList += contacts
                    let rowArray: [Int] = Array(self.startingIndexRow...self.contactList.count - 1)
                    self.startingIndexRow = self.contactList.count
                    let indexPaths = self.makeIndexPaths(fromRowsArray: rowArray)
                    self.delegate?.contactsUpdatedWitSuccess(forIndexPaths: indexPaths)
                } else {
                    self.delegate?.contactsUpdatedWithError(error: error ?? "something went wrong")
                }
            }
        }
    }
    
    private func makeIndexPaths(fromRowsArray rows: [Int]) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        rows.forEach { row in
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
}

// MARK: - extension tableViewDataSource
extension ContactsViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        cell.configureCell(withContact: contactList[indexPath.row])
        if indexPath.row == contactList.count - 1 {
            getContacts()
        }
        return cell
    }
    
}
