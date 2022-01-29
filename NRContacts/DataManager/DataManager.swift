//
//  DataManager.swift
//  NRContacts
//
//  Created by Nikola Rosic on 26/01/2022.
//

import Foundation
import RealmSwift


final class DataManager {
    
    //MARK: - properties
    public static let sharedInstance = DataManager()
    private var session: URLSession
    private var cachedDataForContactPictures = NSCache <NSString, NSData>()
    private var nextPageForUpdate = 1
    
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
        
        //check and load if there is page in locale
        if let datas = loadPageDataFromLocal() {
            print("PAGE FOR UPDATE : \(nextPageForUpdate), LOADED PAGES : \(datas.count)")
            if nextPageForUpdate <= datas.count {
                let pageData = datas[nextPageForUpdate - 1]
                do {
                    let welcome = try JSONDecoder().decode(DataForContacts.self, from: pageData)
                    if let contacts = welcome.results {
                        self.nextPageForUpdate += 1
                        print("LOADED")
                        completion(contacts, nil)
                        return
                    }
                } catch {
                    completion(nil, error.localizedDescription)
                }
            }
        }
        //get page form API and save data on locale
        let urlString = Constants.urlForContactListPrefix + "\(nextPageForUpdate)" + Constants.urlForContactListSufix
        guard let url = URL(string: urlString) else { completion(nil, "URL error"); return }
        
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
                            self.nextPageForUpdate += 1
                            let isSaved = self.savePageDataToLocal(data: data)
                            if isSaved {
                                print("SAVED")
                            }
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
    
    private func savePageDataToLocal(data: Data) -> Bool {
        do {
            let realm = try Realm()
            let contactsData = ContactsDataLocal()
            contactsData.pageData = data
            realm.beginWrite()
            realm.add(contactsData)
            do {
                try realm.commitWrite()
                return true
            } catch {
                return false
            }
        } catch {
            return false
        }
    }
    
    private func loadPageDataFromLocal() -> [Data]? {
        do {
            var dataToReturn = [Data]()
            let datas = try Realm().objects(ContactsDataLocal.self)
            for data in datas {
                dataToReturn.append(data.pageData)
            }
            return dataToReturn
        } catch {
            return nil
        }
    }
    
}
