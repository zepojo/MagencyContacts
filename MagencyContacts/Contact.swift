//
//  Contact.swift
//  MagencyContacts
//
//  Created by Paul Ulric on 17/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import Foundation

struct Contact {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var jobTitle: String?
    var avatarUrlString: String?
    
    // avatarUrlString is used to store the value from the JSON (as a string)
    // In practice, we will mostly need and URL, which is the aim of this computed property
    // We also complete it with the domain name if it's not present
    var avatarUrl: NSURL? {
        get {
            var url: NSURL?
            if avatarUrlString != nil {
                let string = avatarUrlString!.hasPrefix("http") ? avatarUrlString! : "\(DataFetcher.sourceUrlString)\(avatarUrlString!)"
                url = NSURL(string: string)
            }
            return url
        }
    }
}