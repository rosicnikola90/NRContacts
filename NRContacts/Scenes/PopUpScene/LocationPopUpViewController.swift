//
//  locationPopUpView.swift
//  NRContacts
//
//  Created by Nikola Rosic on 27/01/2022.
//

import UIKit
import MapKit

final class LocationPopUpViewController: UIViewController {
    
    // MARK: - properties
    private let latitudeString: String
    private let longitudeString: String
    private let contactName: String
    private let mapView = MKMapView()
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViewIfNeeded()
        setupView()
        setupMapView()
    }

    deinit {
        print("deinit locationPopUpViewController")
    }
    
    init(withLatitude lat: String, andLongitude lon: String, forContactName name: String) {
        self.latitudeString = lat
        self.longitudeString = lon
        self.contactName = name
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupMapView() {
        guard let lat = CLLocationDegrees(latitudeString) else { return }
        guard let lon = CLLocationDegrees(longitudeString) else { return }
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = contactName
        mapView.addAnnotation(annotation)
    }
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        //mapView.isUserInteractionEnabled = false
        title = "Location"
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

