//
//  ContactTableVIewCell.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import UIKit

final class ContactTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "contactTableViewCell"
    
    private let contactImageView = NRImageView(image: UIImage())
    private let locationImageView = NRImageView(image: UIImage(systemName: "location"))
    private let contactSexImageView = NRImageView(image: UIImage())
    private let emailImageView = NRImageView(image: UIImage(systemName: "envelope"))
    private let phoneCallImageView = NRImageView(image: UIImage(systemName: "phone"))
    
    private let contactNameLabel: NRLabel = {
        let label = NRLabel()
        label.textAlignment = .left
        return label
    }()
    
    private let contactTitleLabel: NRLabel = {
        let label = NRLabel()
        label.textAlignment = .left
        return label
    }()
    
    private let contactAgeLabel: NRLabel = {
        let label = NRLabel()
        label.textAlignment = .left
        return label
    }()
    
    private let contactAddressLabel: NRLabel = {
        let label = NRLabel()
        label.textAlignment = .left
        return label
    }()
    
    private let contactCurrentTimeLabel: NRLabel = {
        let label = NRLabel()
        label.textAlignment = .left
        return label
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .secondarySystemBackground
        //selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    
    
    // MARK: - SetupViews
    private func setupView() {
        
        [contactImageView, contactSexImageView, locationImageView, contactNameLabel, contactTitleLabel, contactAgeLabel, contactAddressLabel, emailImageView, phoneCallImageView, contactCurrentTimeLabel].forEach { view in
            contentView.addSubview(view)
        }
        
        [contactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
         contactImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
         contactImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
         contactImageView.widthAnchor.constraint(equalTo: contactImageView.heightAnchor)].forEach { constraint in
            constraint.isActive = true }
        
    }
}

