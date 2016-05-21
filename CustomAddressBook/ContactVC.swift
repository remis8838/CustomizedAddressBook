//
//  ContactVC.swift
//  CustomAddressBook
//
//  Created by Master on 5/18/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit
import AddressBook
import SwiftAddressBook


protocol selectedContactsFromContacts {
    func selectedContacts(contacts: [CustomAddressBookRecord])
}



class ContactVC: UITableViewController {

    
    
    var delegate: selectedContactsFromContacts? = nil
    
    var isActvatedSearchBar: Bool = false
    @IBAction func btn_done_tapped(sender: UIBarButtonItem) {
        if self.selectedContacts.count != 0{
            delegate?.selectedContacts(self.selectedContacts)
            self.performSegueWithIdentifier("getBack", sender: self)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No contacts, please selected one at least.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
                
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    var contactObj = CustomAddressBook()
    var contactsList: [CustomAddressBookRecord] = []
    var completed: [[CustomAddressBookRecord]] = []
    var sectionTitle: [String] = []
    
    var filteredCompleted: [[CustomAddressBookRecord]] = []
    var filteredSectionTitle: [String] = []
    var filteredContacts: [CustomAddressBookRecord] = []
    
    var selectedContacts: [CustomAddressBookRecord] = []
    var selected_last: [String] = []
    //UISearchViewController
    var resultsSearchController = UISearchController()

    
    
    //NotificationCenter
    
    func gotFinished(notification: NSNotification)  {
        let msg = notification.object as! String
        switch msg {
        case "finished":
            dispatch_async(dispatch_get_main_queue()) {
                self.contactsList = myContacts.sort({$0.last_name < $1.last_name})
                (self.sectionTitle, self.completed) = makingDataForSectionAndRow(myContacts.sort({$0.last_name < $1.last_name}))
//                self.sectionTitle = (completed.keys as? [String])!
                self.tableView.reloadData()
            }
        case "Denied", "Restricted":
            NSLog("Unauthorized")
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            let settingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { (action: UIAlertAction) in
                let url = NSURL(string: UIApplicationOpenSettingsURLString)
                UIApplication.sharedApplication().openURL(url!)
            })
            showAlert(
                title: "Permission Denied",
                message: "You have not permission to access contacts. Please allow the access the Settings screen.",
                actions: [okAction, settingsAction])
        default:
            let alert = UIAlertController(title: "Warnning", message: msg, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
                self.viewDidLoad()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) in
                
            })
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContactVC.gotFinished(_:)), name: "gotAddress", object: nil)
        super.viewDidLoad()
        
        self.tableView.rowHeight = 108
        contactObj.fetching_contacts()
        //Search Bar
        self.resultsSearchController = UISearchController(searchResultsController: nil)
        self.resultsSearchController.searchResultsUpdater = self
        self.resultsSearchController.dimsBackgroundDuringPresentation = false
        self.resultsSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultsSearchController.searchBar
        //
        self.hideKeyboardWhenTappedAround()
    }
    //
    
    //
    func filterContactsForSearchText(searchText: String, scope: String = "All"){
        filteredContacts = myContacts.filter({$0.last_name.containsString(searchText)})
        self.tableView.reloadData()
    }
}
//UISeachView
extension ContactVC: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredCompleted.removeAll(keepCapacity: false)
        print("SearchString: \(self.resultsSearchController.searchBar.text?.lowercaseString)")
        self.filteredContacts = myContacts.filter({ (contact) -> Bool in
            if contact.last_name.containsString(self.resultsSearchController.searchBar.text!) ||
               contact.first_name.containsString(self.resultsSearchController.searchBar.text!) ||
               contact.company.containsString(self.resultsSearchController.searchBar.text!) ||
               contact.email.containsString(self.resultsSearchController.searchBar.text!){
                return true
            }else if contact.last_name.lowercaseString.containsString(self.resultsSearchController.searchBar.text!.lowercaseString) ||
                contact.first_name.lowercaseString.containsString(self.resultsSearchController.searchBar.text!.lowercaseString) ||
                contact.company.lowercaseString.containsString(self.resultsSearchController.searchBar.text!.lowercaseString) ||
                contact.email.lowercaseString.containsString(self.resultsSearchController.searchBar.text!.lowercaseString){
                return true
            }else{
                return false
            }
        })
        (self.filteredSectionTitle, self.filteredCompleted) = makingDataForSectionAndRow(self.filteredContacts.sort({$0.last_name < $1.last_name}))
        self.tableView.reloadData()
    }
}

//TableView
extension ContactVC{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return self.alpha.count
        return self.resultsSearchController.active ? self.filteredCompleted.count:self.completed.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.contactsList.count
        if self.resultsSearchController.active{
            if self.filteredCompleted.isEmpty{
                return 0
            }
            if self.filteredCompleted[section].count != 0{
                return self.filteredCompleted[section].count
            }else{
                return 0
            }
        }else{
            return self.completed[section].count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var contacts_list = [CustomAddressBookRecord]()
        if self.resultsSearchController.active{
            contacts_list = self.filteredCompleted[indexPath.section]
        }else{
            contacts_list = self.completed[indexPath.section]
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ContactCell
        
        //making bold text of family name
        
        let firstName = contacts_list[indexPath.row].first_name + " "
        let attributedString = NSMutableAttributedString(string: firstName)
        let attrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        let boldStr = NSMutableAttributedString(string: contacts_list[indexPath.row].last_name, attributes: attrs)
        attributedString.appendAttributedString(boldStr)
        
        cell.lbl_contact_name.attributedText = attributedString
        cell.lbl_contact_company.text = contacts_list[indexPath.row].company
        if myContacts[indexPath.row].company == ""{
            cell.lbl_contact_company.text = "No company"
        }
        cell.lbl_contact_email.text = contacts_list[indexPath.row].email
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selected = self.resultsSearchController.active ? self.filteredCompleted[indexPath.section]:self.completed[indexPath.section]
        
        if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) {
            if selectedRow.accessoryType == .None{
                selectedRow.accessoryType = .Checkmark
                self.selectedContacts.append(selected[indexPath.row])
                self.selected_last.append(selected[indexPath.row].last_name)
                print("Selected: \(self.selectedContacts.count): \(self.selected_last)")
            }else{
                selectedRow.accessoryType = .None
                let indexToRemove = self.selected_last.indexOf(selected[indexPath.row].last_name)
                self.selectedContacts.removeAtIndex(indexToRemove!)
                self.selected_last.removeAtIndex(indexToRemove!)
                print("Selected: \(self.selectedContacts.count): \(self.selected_last)")
            }
        }
        
        
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.alphaBet[section]
        return self.resultsSearchController.active ? (filteredCompleted.isEmpty ? "":self.filteredSectionTitle[section]):self.sectionTitle[section]
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    //A-Z
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return alphaBet
    }
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return alphaBet.indexOf(title)!
    }
}
extension ContactVC{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContactVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
//        self.searchBar.showsCancelButton = false
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "getBack"{
            let mainView = segue.destinationViewController as! ViewController
            mainView.selectedContacts = self.selectedContacts
        }
    }
    private func showAlert(title title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        for action in actions {
            alert.addAction(action)
        }
        
        dispatch_async(dispatch_get_main_queue(), { [unowned self] () in
            self.presentViewController(alert, animated: true, completion: nil)
            })
    }
}