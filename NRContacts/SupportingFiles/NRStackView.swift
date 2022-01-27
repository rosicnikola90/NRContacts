//
//  NRStackView.swift
//  NRContacts
//
//  Created by Nikola Rosic on 27/01/2022.
//

import UIKit


final class NRStackView: UIStackView {

    private let defaultSpacing: CGFloat = 8.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customSettings()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        customSettings()
    }
    
    private func customSettings() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .fill
        self.alignment = .leading
        self.spacing = 5
        self.axis = .horizontal
    }

}
