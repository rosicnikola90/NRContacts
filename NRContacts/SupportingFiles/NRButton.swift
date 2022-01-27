//
//  NRButton.swift
//  NRContacts
//
//  Created by Nikola Rosic on 27/01/2022.
//

import UIKit


final class NRButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
    }
}
