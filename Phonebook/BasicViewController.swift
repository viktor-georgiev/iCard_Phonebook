//
//  BasicViewController.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

//basic class for the view controllers
//created to share common information

import UIKit

class BasicViewController: UIViewController {
    
    enum ViewControllerTitles:       String {
        case Contacts                = "Contacts"
        case NewContact              = "New Contact"
        case EditContact             = "Edit Contact"
        case ContactInformation      = "Contact Info"
        case Filters                 = "Filters"
        case Countries               = "Choose Country"
    }
    
    enum NavigationItemTitles:       String {
        case Add                     = "Add"
        case Confirm                 = "Confirm"
        case Save                    = "Save"
        case Cancel                  = "Cancel"
        case Back                    = "Back"
    }
    
    enum CellIdentifiers:            String {
        case ContactCell             = "ContactCell"
        case CountryCell             = "CountryCell"
    }
    
    enum SegueIdentifiers:           String {
        case AddContactSegue         = "AddContactSegue"
        case FiltersSegue            = "FiltersSegue"
        case EditContactSegue        = "EditContactSegue"
        case ContactInformationSegue = "ContactInformationSegue"
        case CountriesSegue          = "CountriesSegue"
    }
    
    enum AlertControllerActions:     String {
        case Ok                      = "Ok"
        case Cancel                  = "Cancel"
    }
    
    func popController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
