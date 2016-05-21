//
//  Utilities.swift
//  CustomAddressBook
//
//  Created by Master on 5/18/16.
//  Copyright © 2016 Master. All rights reserved.
//

import Foundation
import AddressBook
import SwiftAddressBook

var myContacts: [CustomAddressBookRecord] = []


class CustomAddressBookRecord{
    var first_name: String
    var last_name: String
    var company: String
    var email: String
    
    init(firstName: String, lastName: String, companyName: String, email: String){
        self.first_name = firstName
        self.last_name = lastName
        self.company = companyName
        self.email = email
    }
}
//checking email address from string
func isValidEmail(testStr:String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
}

func sortContacts(contactsList: [CustomAddressBookRecord]) -> [CustomAddressBookRecord] {
    var sortedContacts: [CustomAddressBookRecord] = []
    sortedContacts = sortedContacts.sort({$0.last_name > $1.last_name })
    return sortedContacts
}
func makingDataForSectionAndRow(contacts: [CustomAddressBookRecord]) -> ([String],[[CustomAddressBookRecord]]){
    
    
    var returnedData = [[CustomAddressBookRecord]]()
    var contactsList = [CustomAddressBookRecord]()
    var keyString = ""
    var specialContacts = [CustomAddressBookRecord]()
    var specialKeyString = ""
    var sectionTitle: [String] = []
    
    
    
    let first_LastName = contacts.map { (p) -> (String?)? in
        return p.last_name
    }
    for index in 0..<first_LastName.count{
        let lastName = first_LastName[index]!
        let first_letter = String(lastName![(lastName?.startIndex)!])
        if (alphaBet.indexOf(first_letter) != nil){
            if keyString != first_letter{
                if keyString == ""{
                    keyString = first_letter
                    contactsList.append(contacts[index])
                }else{
                    sectionTitle.append(keyString)
                    returnedData.append(contactsList)
                    contactsList.removeAll()
                    keyString = first_letter
                    contactsList.append(contacts[index])
                }
            }else{
                contactsList.append(contacts[index])
            }
        }else{
            if contactsList.count > 0{
                sectionTitle.append(keyString)
                returnedData.append(contactsList)
                contactsList.removeAll()
            }
            specialContacts.append(contacts[index])
            if index == first_LastName.count - 1{
                specialKeyString = "#"
                sectionTitle.append(specialKeyString)
                returnedData.append(specialContacts)
            }
        }
    }
    print("Section titles: \(sectionTitle.count): \(sectionTitle)")
    print("Every contacts: \(returnedData.count)")
    return (sectionTitle, returnedData)
}
