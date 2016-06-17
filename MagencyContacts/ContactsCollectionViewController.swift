//
//  ContactsCollectionViewController.swift
//  MagencyContacts
//
//  Created by Paul Ulric on 17/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ContactsCollectionViewController: UICollectionViewController {
    
    var contacts = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowContactDetailsSegue" {
            if let detailsVC = segue.destinationViewController as? ContactDetailsViewController,
            let cell = sender as? ContactCollectionViewCell {
                detailsVC.contact = cell.contact
            }
        }
    }
    
    // Action bound to the Exit of the ContactDetailsViewController in IB
    // No need for code
    @IBAction func unwindToCollection(segue: UIStoryboardSegue) {
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ContactCollectionViewCell.identifier, forIndexPath: indexPath) as! ContactCollectionViewCell
        cell.contact = contacts[indexPath.row]
        return cell
    }

}
