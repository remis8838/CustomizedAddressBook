//
//  ContactCell.swift
//  CustomAddressBook
//
//  Created by Master on 5/18/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var lbl_contact_name: UILabel!
    @IBOutlet weak var lbl_contact_company: UILabel!
    @IBOutlet weak var lbl_contact_email: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
