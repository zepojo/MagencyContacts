//
//  ContactDetailsViewController.swift
//  MagencyContacts
//
//  Created by Paul Ulric on 17/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // In the app flow, the contact is assigned before the view is loaded
    // So we must not set the UI elements values if the view doesn't exist yet
    var contact: Contact? {
        didSet {
            guard self.view != nil else { return }
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    func updateUI() {
        self.loadAvatar(contact?.avatarUrl)
        firstNameLabel.text = contact?.firstName?.characters.count > 0 ? contact?.firstName : "unknown"
        lastNameLabel.text = contact?.lastName?.characters.count > 0 ? contact?.lastName : "unknown"
        emailLabel.text = contact?.email?.characters.count > 0 ? contact?.email : "unknown"
        jobTitleLabel.text = contact?.jobTitle?.characters.count > 0 ? contact?.jobTitle : "unknown"
    }

    func loadAvatar(url: NSURL?) {
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
