//
//  DataFetcher.swift
//  MagencyContacts
//
//  Created by Paul Ulric on 17/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import Foundation

class DataFetcher: NSObject {
    
    static let sourceUrlString = "http://ea0000-mich.preevent.magency.fr"
    
    static let sharedInstance = DataFetcher()
    
    dynamic var isFetching: Bool = false
    
    private override init() {}
    
    func fetchContacts(completionHandler: ([Contact]?, NSError?) -> Void) {
        self.isFetching = true
        
        let url = NSURL(string: "\(DataFetcher.sourceUrlString)/contacts.json")!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            self.isFetching = false
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let statusCode = (response as! NSHTTPURLResponse).statusCode
            if statusCode == 200 {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    let contacts = self.parseContacts(json)
                    completionHandler(contacts, nil)
                } catch {
                    print("Error: \(error)")
                }
            }
            else {
                let errorInfo = [NSLocalizedDescriptionKey : "Request has failed (status code: \(statusCode))"]
                let requestError = NSError(domain: "DataFetcher", code: statusCode, userInfo: errorInfo)
                completionHandler(nil, requestError)
            }
        }
        task.resume()
    }
    
    func parseContacts(json: AnyObject) -> [Contact] {
        var contacts = [Contact]()
        for contactJSON in json as! [AnyObject] {
            var contact = Contact()
            if let contactId = contactJSON["id"] as? Int { contact.id = contactId }
            if let contactLastName = contactJSON["last_name"] as? String { contact.lastName = contactLastName }
            if let contactFirstName = contactJSON["first_name"] as? String { contact.firstName = contactFirstName }
            if let contactEmail = contactJSON["email"] as? String { contact.email = contactEmail }
            if let contactAvatarUrl = contactJSON["avatar_url"] as? String { contact.avatarUrlString = contactAvatarUrl }
            if let contactJobTitle = contactJSON["cs3"] as? String { contact.jobTitle = contactJobTitle }
            contacts.append(contact)
        }
        return contacts
    }
}
