//
//  NRNavigationController.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import UIKit

final class NRNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barTintColor = .systemBlue
        self.navigationBar.tintColor = .label
//        self.navigationBar.layer.shadowColor = UIColor.systemBlue.cgColor
//        self.navigationBar.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        self.navigationBar.layer.shadowRadius = 4.0
//        self.navigationBar.layer.shadowOpacity = 1.0
    }
    

}
