//
//  WelcomeViewController.swift
//  MagencyContacts
//
//  Created by Paul Ulric on 17/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var contacts: [Contact]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataFetcher.sharedInstance.addObserver(self, forKeyPath: "isFetching", options: .New, context: nil)
    }
    
    deinit {
        DataFetcher.sharedInstance.removeObserver(self, forKeyPath: "isFetching", context: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Actions
    
    @IBAction func showContacts(sender: AnyObject) {
        DataFetcher.sharedInstance.fetchContacts { (contacts: [Contact]?, error: NSError?) in
            dispatch_async(dispatch_get_main_queue(), {
                guard error == nil else {
                    self.displayError(error!)
                    return
                }
                self.contacts = contacts
                // Fire the transition to the contacts collection once we've retrieved them all
                self.performSegueWithIdentifier("ShowContactCollectionSegue", sender: self)
            })
        }
    }
    
    
    func displayError(error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When transitioning to the contacts collection, assign the existing contacts to the collection
        if segue.identifier == "ShowContactCollectionSegue" {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            if let contactCollection = segue.destinationViewController as? ContactsCollectionViewController {
                contactCollection.contacts = self.contacts ?? []
            }
        }
    }
    
    // Mark: - Observers
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "isFetching" {
            dispatch_async(dispatch_get_main_queue(), {
                let isFetching = DataFetcher.sharedInstance.isFetching
                let buttonTitle = isFetching ? "Loading..." : "Show Contacts"
                self.actionButton.setTitle(buttonTitle, forState: .Normal)
                self.actionButton.enabled = !isFetching
                isFetching ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            })
        }
    }
}

