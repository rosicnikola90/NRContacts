//
//  ContactTableViewCell.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import UIKit

protocol ContactTableViewCellDelegate: class {
    
    func locationHaveNoData()

}

final class ContactTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "contactTableViewCell"
    
    private let placeholderImage = UIImage(systemName: "person")
    private let contactImageView = NRImageView(image: UIImage())
    private let locationImageButton = NRButton()
    private let contactGenderImageView = NRImageView(image: UIImage())
    private let contactNationalityImageView = NRImageView(image: UIImage())
    private let emailButton = NRButton()
    private let phoneCallButton = NRButton()
    private let contactNameLabel = NRLabel()
    private let contactLastNameLabel = NRLabel()
    private let contactTitleLabel = NRLabel()
    private let contactAgeLabel = NRLabel()
    private let contactAddressLabel = NRLabel()
    private let contactCurrentTimeLabel = NRLabel()
    
    private var id = ""
    private var natId = ""
    private var contact: Contact?
    weak var delegate: ContactTableViewCellDelegate?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tertiarySystemBackground
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
        natId = ""
        contactImageView.image = placeholderImage
        contactGenderImageView.image = nil
        contactTitleLabel.text = nil
        contactNameLabel.text = nil
        contactNameLabel.text = nil
        contactAddressLabel.text = nil
        contactCurrentTimeLabel.text = nil
        contact = nil
    }
    
    @objc private func locationButtonClicked() {
        if let contact = contact {
            guard let latitude = contact.location?.coordinates?.latitude else {
                return
            }
            guard let longitude = contact.location?.coordinates?.longitude else {
                return
            }
            
            sentInfoToVCThatLocationNeedToBePresented(forLat: latitude, andLon: longitude, forName: (contact.name?.first ?? ""))
        }
    }
    
    @objc private func phoneCallButtonClicked() {
        
    }
    
    @objc private func emailButtonClicked() {
        
    }
    
    private func sentInfoToVCThatLocationNeedToBePresented(forLat lat: String, andLon lon: String, forName name: String) {
        let userInfo = [
            "lat" : lat,
            "lon" : lon,
            "name": name
            ]
        NotificationCenter.default.post(name: Notification.Name(Constants.locationNotificationName), object: nil, userInfo: userInfo)
    }
    
    func configureCell(withContact contact: Contact) {
        
        self.contact = contact
        //set title
        if let title = contact.name?.title {
            contactTitleLabel.text = title
        }
        //set first name
        if let firstName = contact.name?.first {
            contactNameLabel.text = firstName
        }
        //set last name
        if let lastName = contact.name?.last {
            contactLastNameLabel.text = lastName
        }
        // set address
        if let address = contact.location?.street?.name {
            if let number = contact.location?.street?.number {
                contactAddressLabel.text = address + ", " + "\(number)"
                if let city = contact.location?.city {
                    contactAddressLabel.text? += ", " + city
                }
                if let state = contact.location?.state {
                    contactAddressLabel.text? += ", " + state
                }
            }
        }
        // set contact date
        if let userOffsetFromUTC = contact.location?.timezone?.offset {
            let nowUTC = Date()
            let filteredString = userOffsetFromUTC.replacingOccurrences(of: ":00", with: "")
            if let timeZoneOffset = Int(filteredString) {
                if let contactLocalDate = Calendar.current.date(byAdding: .hour, value: timeZoneOffset, to: nowUTC) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
                    contactCurrentTimeLabel.text = dateFormatter.string(from: contactLocalDate)
                }
            }
        }
        //set contact gender
        if let gender = contact.gender {
            switch gender {
            case .male:
                contactGenderImageView.image = UIImage(named: "male")
            case .female:
                contactGenderImageView.image = UIImage(named: "female")
            }
        }
        // set contact picture
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
        // set nationality
        if let nationality = contact.nat {
            let urlString = Constants.urlPrefixForFlags + nationality.lowercased()
            natId = urlString
            DataManager.sharedInstance.getImageData(forUrl: urlString) { [weak self] (data, error, id) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let data = data {
                        if let contactNatImage = UIImage(data: data) {
                            if let id = id {
                                if id == self.natId {
                                    self.contactNationalityImageView.image = contactNatImage
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
        locationImageButton.setImage(UIImage(systemName: "location"), for: .normal)
        emailButton.setImage(UIImage(systemName: "envelope"), for: .normal)
        phoneCallButton.setImage(UIImage(systemName: "phone"), for: .normal)
        
        contactTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contactNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        locationImageButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contactCurrentTimeLabel.textAlignment = .center
        locationImageButton.tintColor = .systemOrange
        emailButton.tintColor = .systemBlue
        phoneCallButton.tintColor = .systemGreen
        
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
            constraint.isActive = true }
        
        let firstRowStackView = NRStackView(arrangedSubviews: [contactTitleLabel, contactNameLabel, contactLastNameLabel])
        let secondRowStackView = NRStackView(arrangedSubviews: [locationImageButton, contactAddressLabel])
        let thirdRowStackView = NRStackView(arrangedSubviews: [contactCurrentTimeLabel])
        let fourthRowStackView = NRStackView(arrangedSubviews: [emailButton, phoneCallButton])
        fourthRowStackView.distribution = .fillEqually
        
        let mainSV = NRStackView(arrangedSubviews: [firstRowStackView, secondRowStackView, thirdRowStackView, fourthRowStackView])
        
        mainSV.axis = .vertical
        mainSV.alignment = .fill
        mainSV.distribution = .fillEqually
        mainSV.spacing = 0
        contentView.addSubview(mainSV)
        [mainSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         mainSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
         mainSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
         mainSV.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 12)].forEach { constraint in
            constraint.isActive = true }
        
        contentView.addSubview(contactNationalityImageView)
        [contactNationalityImageView.widthAnchor.constraint(equalToConstant: 20),
         contactNationalityImageView.heightAnchor.constraint(equalToConstant: 15),
         contactNationalityImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
         contactNationalityImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2)].forEach { constraint in
            constraint.isActive = true }
        
        locationImageButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        phoneCallButton.addTarget(self, action: #selector(phoneCallButtonClicked), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(emailButtonClicked), for: .touchUpInside)
    }
}

