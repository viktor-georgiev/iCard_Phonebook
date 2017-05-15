//
//  InformationViewController.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/14/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class ContactInformationViewController: BasicViewController {

    
    //MARK: Variables
    
    var contact                          : Contact!
    
    var country                          : Country?
    
    //MARK: Outlets
    
    @IBOutlet weak var label_Firstname   : UILabel!
    @IBOutlet weak var label_Lastname    : UILabel!
    @IBOutlet weak var label_PhoneNumber : UILabel!
    @IBOutlet weak var label_Email       : UILabel!
    @IBOutlet weak var label_Gender      : UILabel!
    @IBOutlet weak var label_Country     : UILabel!
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupNavigationBar() {
        navigationItem.title = ViewControllerTitles.ContactInformation.rawValue
    }
    
    func setupContent() {
        label_Firstname.text       = (contact.firstname != "") ? contact.firstname : "Not Stated"
        label_Lastname.text        = (contact.lastname  != "") ? contact.lastname  : "Not Stated"
        label_Email.text           = (contact.email     != "") ? contact.email     : "Not Stated"
        label_Gender.text          = (contact.genderId  != -1) ? ((contact.genderId == 0) ? "Male" : "Female") : "Not Stated"
        
        if contact.countryId != -1 {
            country = Country.getCountryById(id: contact.countryId)
            label_PhoneNumber.text = (contact.phoneNumber != -1) ? String.init(format: "+%i %i", (country?.code)!, contact.phoneNumber) : "Not Stated"
            label_Country.text     = country?.name
        } else {
            label_PhoneNumber.text = (contact.phoneNumber != -1) ? String.init(format: "%i", contact.phoneNumber) : "Not Stated"
            label_Country.text     = "Not Stated"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
