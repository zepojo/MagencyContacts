//
//  ContactCollectionViewCell.swift
//  MagencyContacts
//
//  Created by Paul Ulric on 17/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    static let identifier = "ContactCollectionViewCell"
    
    var contact: Contact? {
        didSet {
            self.loadAvatar(contact?.avatarUrl)
            lastNameLabel.text = contact?.lastName
            firstNameLabel.text = contact?.firstName
        }
    }

    func loadAvatar(url: NSURL?) {
        // Display the placeholder avatar here
        // that way, it will be displayed during the loading
        // and it will stay visible if the contact doesn't have an avatar of its own
        avatarImage.image = UIImage(imageLiteral: "placeholder")
        
        guard url != nil else { return }
        
        self.loadingIndicator.startAnimating()
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingIndicator.stopAnimating()
                if data != nil {
                    self.avatarImage.image = UIImage(data: data!)
                }
            })
        }
        task.resume()
    }

}
