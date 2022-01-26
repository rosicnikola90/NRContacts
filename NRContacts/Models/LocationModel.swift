//
//  LocationModel.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import Foundation

struct LocationModel: Codable {
    
    let street: StreetModel?
    let city: String?
    let state: String?
    let country: String?
    let postcode: Int?
    let coordinates: CoordinatesModel?
    let timezone: TimezoneModel?
}

struct StreetModel: Codable {
    
    let number: Int?
    let name: String?
}

struct CoordinatesModel: Codable {
    
    let latitude: String?
    let longitude: String?
}

struct TimezoneModel: Codable {
    
    let offset: String?
    let description: String?
}
