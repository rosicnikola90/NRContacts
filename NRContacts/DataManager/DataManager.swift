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
    func getContacts(_ completion: @escaping([Result]?, String?) -> ()) {
        guard let url = URL(string: Constants.urlForContactList) else { completion(nil, "URL error"); return }
        
        print("getContacts URL: \(url)")
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
                if let data = data, httpResponse.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print(json)
                            let welcome = try JSONDecoder().decode(DataForContacts.self, from: data)
                            if let contacts = welcome.results {
                                completion(contacts, nil)
                            }
                        }
                    } catch {
                        completion(nil, error.localizedDescription)
                    }
                } else {
                    completion(nil, error?.localizedDescription ?? "error with data")
                }
            } else {
                completion(nil, error?.localizedDescription ?? "no response")
            }
        })
        task.resume()
    }
}
