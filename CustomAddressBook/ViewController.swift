//
//  ViewController.swift
//  CustomAddressBook
//
//  Created by Master on 5/18/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit

class ViewController: UIViewController, selectedContactsFromContacts {

    @IBAction func prepareForUnWind(segue: UIStoryboardSegue){
        
    }
    func selectedContacts(contacts: [CustomAddressBookRecord]) {
        self.selectedContacts = contacts
        if self.selectedContacts.count != 0{
            let alert = UIAlertController(title: "Contacts", message: "You has just selected \(self.selectedContacts.count) contact(s)", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
                
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    var selectedContacts: [CustomAddressBookRecord] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.selectedContacts.count != 0{
            let alert = UIAlertController(title: "Contacts", message: "You has just selected \(self.selectedContacts.count) contact(s)", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
                
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

