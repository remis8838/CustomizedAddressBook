//
//  CustomAddressBook.swift
//  CustomAddressBook
//
//  Created by Master on 5/18/16.
//  Copyright © 2016 Master. All rights reserved.
//

import AddressBook
import SwiftAddressBook

class CustomAddressBook{
    
    var groups: [SwiftAddressBookGroup]?
    var person: [SwiftAddressBookPerson]?
    var first_names: [String?]? = []
    var last_names: [String?]? = []
    var companies: [String?]? = []
    var personEmails : [Array<String?>?]? = []
    var error = ""
    
    
    
    // Grant permission and fetching address data from iPhone
    func fetching_contacts(){
        myContacts.removeAll()
        let hasAuthority:ABAuthorizationStatus = SwiftAddressBook.authorizationStatus()
        switch hasAuthority {
        case .Authorized:
            SwiftAddressBook.requestAccessWithCompletion { (success: Bool, error: CFError?) in
                dispatch_async(dispatch_get_main_queue(), {
                    if error != nil{
                        self.error = error.debugDescription
                        return
                    }
                    if success{
                        self.saving_person_info(true)//
                    }
                })
            }
        case .Denied:
            self.error = "Denied"
            NSNotificationCenter.defaultCenter().postNotificationName("gotAddress", object: self.error)
        case .Restricted:
            self.error = "Restricted"
            NSNotificationCenter.defaultCenter().postNotificationName("gotAddress", object: self.error)
        case .NotDetermined:
            SwiftAddressBook.requestAccessWithCompletion { (success: Bool, error: CFError?) in
                dispatch_async(dispatch_get_main_queue(), {
                    if error != nil{
                        self.error = error.debugDescription
                        return
                    }
                    if success{
                        self.saving_person_info(true)//
                    }
                })
            }
        }
        
    }
    //Saving data for tableView
    private func saving_person_info(isASC: Bool){
        
        self.person = swiftAddressBook.allPeople!
        let sources = swiftAddressBook.allSources
        self.groups = []
        for source in sources!{
            let newGroups = swiftAddressBook.allGroupsInSource(source)!
            self.groups = self.groups! + newGroups
        }
        self.first_names = self.person?.map({ (p) -> (String?) in
            return p.firstName
        })
        self.last_names = self.person?.map({ (p) -> (String?) in
            return p.lastName
        })
        self.companies = self.person?.map({ (p) -> (String?) in
            return p.organization
        })
        self.personEmails = self.person?.map({ (p) -> (Array<String?>?) in
            return p.emails?.map{return $0.value}
        })
        //Finding either email or not
        for index in 0..<self.personEmails!.count{
            if self.personEmails![index]?.count > 0{
                for email in self.personEmails![index]!{
                    if isValidEmail(email!){
                        if let emailAddr = email{
                            let firstName = (first_names![index] != nil) ? first_names![index]:" "
                            var companyName = (companies![index] != nil) ? companies![index]:"*****"
                            let lastName = (last_names![index] != nil) ? last_names![index]:companyName
                            companyName = (companies![index] != nil) ? companies![index]:"##########"
                            let emailedPerson = CustomAddressBookRecord(firstName: firstName!,
                                                                        lastName: lastName!,
                                                                        companyName: companyName!,
                                                                        email: emailAddr)
                            myContacts.append(emailedPerson)
                            
                        }
                        
                    }
                }
            }
            
        }
        NSNotificationCenter.defaultCenter().postNotificationName("gotAddress", object: "finished")
    }
}



