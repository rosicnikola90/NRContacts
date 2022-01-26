//
//  ViewController.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import UIKit

final class ContactsViewController: UIViewController {
    

    //MARK: - properties
    private let viewModel = ContactsViewModel()
    
    private let contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        return tableView
    }()
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewModel.getContacts()
    }
    
    //MARK: - metodes
    private func setupView() {
        view.backgroundColor = .tertiarySystemBackground
        contactsTableView.delegate = self
        contactsTableView.dataSource = viewModel
        viewModel.delegate = self
        title = "Contacts"
        
        view.addSubview(contactsTableView)
        [contactsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         contactsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         contactsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         contactsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].forEach { constraint in
            constraint.isActive = true
         }
        contactsTableView.backgroundColor = .clear
        
    }

}

    //MARK: -extension for TableView Delegate
extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    //MARK: -extension for ContactsViewModelDelegate
extension ContactsViewController: ContactsViewModelDelegate {
    
    func contactsUpdatedWitSuccess() {
        contactsTableView.reloadData()
    }
    
    func contactsUpdatedWithError(error: String) {
        
    }
}


