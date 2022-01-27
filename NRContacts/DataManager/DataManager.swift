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
    private var cachedDataForContactPictures = NSCache <NSString, NSData>()
    
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
    func getContacts(_ completion: @escaping([Contact]?, String?) -> ()) {
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
                        let welcome = try JSONDecoder().decode(DataForContacts.self, from: data)
                        if let contacts = welcome.results {
                            completion(contacts, nil)
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
    
    func getImageData(forUrl urlString: String, _ completion: @escaping(Data?, String?, String?) -> ()) {
        
        if let imageData = cachedDataForContactPictures.object(forKey: NSString(string: urlString)) {
            completion(imageData as Data, nil, urlString)
            return
        }
    
        guard let url = URL(string: urlString) else { completion(nil, "URL error", nil); return }
        print("getImageData URL: \(url)")
        let task = session.downloadTask(with: url) {
            (localURL, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription, nil)
                }
                if let localURL = localURL, httpResponse.statusCode == 200 {
                    do {
                        let data = try Data(contentsOf: localURL)
                        self.cachedDataForContactPictures.setObject(data as NSData, forKey: NSString(string: urlString))
                        completion(data, nil, urlString)
                    } catch let error {
                        completion(nil, error.localizedDescription, nil)
                    }
                } else {
                    completion(nil, error?.localizedDescription ?? "error with data", nil)
                }
            } else {
                completion(nil, error?.localizedDescription ?? "no response", nil)
            }
        }
        task.resume()
    }
    }
