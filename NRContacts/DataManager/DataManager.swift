//
//  DataManager.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import Foundation


final class DataManager {
    
    //MARK: - properties
    public static let sharedInstance = DataManager()
    private var session: URLSession
    
    //MARK: - init
    private init() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        self.session = session
    }
    
    deinit {
        print("DataManager deinit")
    }
    
    //MARK: - methods
    
}
