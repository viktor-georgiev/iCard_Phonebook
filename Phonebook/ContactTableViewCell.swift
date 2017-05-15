//
//  ContactTableViewCell.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/14/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
