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
    private let placeholderImage = UIImage(systemName: "person")
    private let contactImageView = NRImageView(image: UIImage())
    private let locationImageView = NRImageView(image: UIImage(systemName: "location"))
    private let contactGenderImageView = NRImageView(image: UIImage())
    private let emailImageView = NRImageView(image: UIImage(systemName: "envelope"))
    private let phoneCallImageView = NRImageView(image: UIImage(systemName: "phone"))
    
    var id = ""
    
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
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        
        id = ""
        contactImageView.image = placeholderImage
        
    }
    
    func configureCell(withContact contact: Contact) {
        
        if let title = contact.name?.title {
            contactTitleLabel.text = title
        }
        
        if let urlString = contact.picture?.medium {
            self.id = urlString
            DataManager.sharedInstance.getImageData(forUrl: urlString) { [weak self] (data, error, id) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let data = data {
                        if let contactImage = UIImage(data: data) {
                            if let id = id {
                                if id == self.id {
                                    self.contactImageView.image = contactImage
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - SetupViews
    private func setupCell() {
        contactImageView.image = placeholderImage
        [contactImageView, contactGenderImageView, locationImageView, contactNameLabel, contactTitleLabel, contactAgeLabel, contactAddressLabel, emailImageView, phoneCallImageView, contactCurrentTimeLabel].forEach { view in
            contentView.addSubview(view)
        }
        
        [contactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
         contactImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
         contactImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
         contactImageView.widthAnchor.constraint(equalTo: contactImageView.heightAnchor)].forEach { constraint in
            constraint.isActive = true }
        
//        contactImageView.layer.shadowColor = UIColor.red.cgColor
//        contactImageView.layer.shadowOpacity = 0.5
//        contactImageView.layer.shadowOffset = .zero
//        contactImageView.layer.shadowRadius = 10
    }
}

