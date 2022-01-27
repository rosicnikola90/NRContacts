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
    private let locationImageButton = NRButton()
    private let contactGenderImageView = NRImageView(image: UIImage())
    private let emailButton = NRButton()
    private let phoneCallButton = NRButton()
    private let contactNameLabel = NRLabel()
    private let contactLastNameLabel = NRLabel()
    private let contactTitleLabel = NRLabel()
    private let contactAgeLabel = NRLabel()
    private let contactAddressLabel = NRLabel()
    private let contactCurrentTimeLabel = NRLabel()
    
    private var id = ""
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .secondarySystemBackground
        selectionStyle = .none
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
        contactGenderImageView.image = nil
        contactTitleLabel.text = nil
        contactNameLabel.text = nil
        contactNameLabel.text = nil

    }
    
    func configureCell(withContact contact: Contact) {
        
        if let title = contact.name?.title {
            contactTitleLabel.text = title
        }
        
        if let firstName = contact.name?.first {
            contactNameLabel.text = firstName
        }
        
        if let lastName = contact.name?.last {
            contactLastNameLabel.text = lastName
        }
        
        if let gender = contact.gender {
            switch gender {
            case .male:
                contactGenderImageView.image = UIImage(named: "male")
            case .female:
                contactGenderImageView.image = UIImage(named: "female")
            }
        }
        
        if let urlString = contact.picture?.large {
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
        locationImageButton.setImage(UIImage(named: "location"), for: .normal)
        emailButton.setImage(UIImage(systemName: "envelope"), for: .normal)
        phoneCallButton.setImage(UIImage(systemName: "phone"), for: .normal)
        locationImageButton.widthAnchor.constraint(equalTo: locationImageButton.heightAnchor).isActive = true
        
        contactTitleLabel.backgroundColor = .gray
        contactTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contactNameLabel.backgroundColor = .cyan
        contactNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contactLastNameLabel.backgroundColor = .blue
        
        [contactImageView].forEach { view in
            contentView.addSubview(view)
        }
        
        [contactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
         contactImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
         contactImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
         contactImageView.widthAnchor.constraint(equalTo: contactImageView.heightAnchor)].forEach { constraint in
            constraint.isActive = true }
        
        contactImageView.addSubview(contactGenderImageView)
        contactGenderImageView.backgroundColor = .systemBlue
        [contactGenderImageView.widthAnchor.constraint(equalTo: contactImageView.widthAnchor, multiplier: 0.15),
         contactGenderImageView.heightAnchor.constraint(equalTo: contactGenderImageView.widthAnchor),
         contactGenderImageView.bottomAnchor.constraint(equalTo: contactImageView.bottomAnchor, constant: -8),
         contactGenderImageView.trailingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: -8)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        let firstRowStackView = NRStackView(arrangedSubviews: [contactTitleLabel, contactNameLabel, contactLastNameLabel])
        firstRowStackView.backgroundColor = .red
        
        let secondRowStackView = NRStackView(arrangedSubviews: [locationImageButton, contactAddressLabel])
        secondRowStackView.backgroundColor = .green
        let thirdRowStackView = NRStackView(arrangedSubviews: [contactCurrentTimeLabel])
        thirdRowStackView.backgroundColor = .red

        let fourthRowStackView = NRStackView(arrangedSubviews: [emailButton, phoneCallButton])
        fourthRowStackView.backgroundColor = .green

        let mainSV = NRStackView(arrangedSubviews: [firstRowStackView, secondRowStackView, thirdRowStackView, fourthRowStackView])
        
        mainSV.axis = .vertical
        mainSV.alignment = .fill
        mainSV.distribution = .fillEqually
        mainSV.spacing = 8
        contentView.addSubview(mainSV)
        [mainSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         mainSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
         mainSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
         mainSV.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 12)].forEach { constraint in
            constraint.isActive = true
         }
        
        
    }
}

