//
//  NRImageView.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import UIKit

final class NRImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.layer.cornerRadius = self.frame.size.height / 2
    }
    
}
