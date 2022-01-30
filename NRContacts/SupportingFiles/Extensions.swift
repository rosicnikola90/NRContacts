//
//  Extensions.swift
//  NRContacts
//
//  Created by Nikola Rosic on 27/01/2022.
//

import UIKit


extension UIViewController {
    
    static let activityIndicator = UIActivityIndicatorView()
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startLoading() {
        let activityIndicator = UIViewController.activityIndicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.systemRed
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.style = UIActivityIndicatorView.Style.large

        DispatchQueue.main.async {
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        let activityIndicator = UIViewController.activityIndicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    )}
}
