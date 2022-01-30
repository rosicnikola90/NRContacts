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
    private let realm: Realm?
    private var imagesFromLocale: [String: Data]?
    private var isFetchingDataInProgress = false
    private var fetchedContactData: [Data]?

    
    //MARK: - init
    private init() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        self.session = session
        self.realm = try? Realm()
        self.fetchedContactData = loadPageDataFromLocal()
        self.imagesFromLocale = loadImagesFromLocale()
    }
    
    deinit {
        print("DataManager deinit")
    }
    
    //MARK: - methods
    func getContacts(_ completion: @escaping([Contact]?, String?) -> ()) {
        guard !isFetchingDataInProgress else { return }

        isFetchingDataInProgress = true

        //check and load if there is page in locale
        if let datas = fetchedContactData {
            print("PAGE FOR UPDATE : \(nextPageForUpdate), LOADED PAGES : \(datas.count)")
            if nextPageForUpdate <= datas.count {
                let pageData = datas[nextPageForUpdate - 1]
                do {
                    let welcome = try JSONDecoder().decode(DataForContacts.self, from: pageData)
                    if let contacts = welcome.results {
                        self.nextPageForUpdate += 1
                        print("LOADED")
                        isFetchingDataInProgress = false
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
        guard let url = URL(string: urlString) else { completion(nil, "URL error"); isFetchingDataInProgress = false; return }
        
        print("getContacts URL: \(url)")
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            self.isFetchingDataInProgress = false
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
                            self.savePageDataToLocal(data: data)
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
        
        if let imageFromLocale = imagesFromLocale?[urlString] {
            completion(imageFromLocale, nil, urlString)
            return
        }
        
        
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
                        self.saveImage(imageURL: urlString as NSString, andImageData: data as NSData)
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
    
    private func savePageDataToLocal(data: Data) {
        guard let realm = realm else { return }
        DispatchQueue.main.async {
            let contactsData = ContactsDataLocal()
            contactsData.pageData = data
            realm.beginWrite()
            realm.add(contactsData)
            do {
                try realm.commitWrite()
                return
            } catch {
                return
            }
        }
    }
    
    private func loadPageDataFromLocal() -> [Data]? {
        guard let realm = realm else { return nil }
        var dataToReturn = [Data]()
        let datas = realm.objects(ContactsDataLocal.self)
        for data in datas {
            dataToReturn.append(data.pageData)
        }
        return dataToReturn
    }
    
    private func saveImage(imageURL url: NSString, andImageData data: NSData) {
        guard let realm = realm else { return }
        DispatchQueue.main.async {
            let imageData = ImageDataLocal()
            imageData.imageData = data
            imageData.imageURL = url
            realm.beginWrite()
            realm.add(imageData)
            do {
                try realm.commitWrite()
                print("IMAGE SAVED")
            } catch {
                print("error saving image : \(url)")
                return
            }
        }
    }
       
    private func loadImagesFromLocale() -> [String : Data]? {
        guard let realm = realm else { return nil }
        var dictionaryToReturn: [String : Data] = [:]
        let images = realm.objects(ImageDataLocal.self)
        for image in images {
            dictionaryToReturn[image.imageURL as String] = image.imageData as Data
        }
        return dictionaryToReturn
    }
    
    
}
