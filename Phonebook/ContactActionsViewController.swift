//
//  ContactActionsViewController.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/15/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class ContactActionsViewController: BasicViewController {
    
    var contactProtocol                : ContactProtocol?
    
    enum ContactActions                : String {
        case AddContact                = "Are you sure you want to add this contact?"
        case EditContact               = "Are you sure you want to edit this contact?"
    }
    
    enum FieldErrors                   : String {
        case NameMissing               = "A name is required"
        case PhoneMissing              = "A phone number is required"
        case PhoneNotCorrect           = "Entered phone number is not correct"
        case EmailNotCorrect           = "Entered email is not valid"
    }
    
    enum ActionSuccess                 : String {
        case AddedContact              = "Contact added successfully"
        case EditedContact             = "Contact edited successfully"
    }
    
    enum ActionError                   : String {
        case AddError                  = "Error adding contact"
        case EditError                 = "Error editing contact"
    }
    

    func contactAction(shouldAdd       : Bool,
                       contact         : Contact,
                       firstname       : String,
                       lastname        : String,
                       countryId       : Int,
                       email           : String,
                       phoneNumberText : String,
                       genderId : Int) {
        
        var takeAction      = true
        var presentingError = false
        
        var phoneNumber     = -1
        
        if firstname.characters.count == 0 && lastname.characters.count == 0 {
            presentSingleActionAlertController(message: FieldErrors.NameMissing.rawValue)
            
            presentingError = true
            takeAction      = false
        }
        
        if phoneNumberText.characters.count == 0 {
            if !presentingError {
                presentSingleActionAlertController(message: FieldErrors.PhoneMissing.rawValue)
                presentingError = true
            }
            
            takeAction = false
        } else if validatePhoneNumber(phoneNumber: phoneNumberText) {
            phoneNumber = (phoneNumberText as NSString).integerValue
        } else {
            if !presentingError {
                presentSingleActionAlertController(message: FieldErrors.PhoneNotCorrect.rawValue)
                presentingError = true
            }
            
            takeAction = false
        }
        
        if email.characters.count > 0 && !validateEmail(email: email) {
            if !presentingError {
                presentSingleActionAlertController(message: FieldErrors.EmailNotCorrect.rawValue)
                presentingError = true
            }
            
            takeAction = false
        }
        
        if(takeAction) {
            let confirmAlertController = UIAlertController.init(
                title: "Phoneboook",
                message: shouldAdd ? ContactActions.AddContact.rawValue : ContactActions.EditContact.rawValue,
                preferredStyle: .alert
            )
            confirmAlertController.addAction(UIAlertAction.init(title: AlertControllerActions.Cancel.rawValue, style: .cancel, handler: nil))
            
            confirmAlertController.addAction(UIAlertAction.init(title: AlertControllerActions.Ok.rawValue, style: .default, handler: { (UIAlertAction) in
                
                contact.firstname   = firstname
                contact.lastname    = lastname
                contact.countryId   = countryId
                contact.email       = email
                contact.phoneNumber = phoneNumber
                contact.genderId    = genderId
                
                if shouldAdd {
                    if Contact.addContact(contact: contact) {
                        self.presentSingleActionAlertController(message: shouldAdd ? ActionSuccess.AddedContact.rawValue : ActionSuccess.EditedContact.rawValue)
                    } else {
                        self.presentSingleActionAlertController(message: ActionError.AddError.rawValue)
                    }
                } else {
                    if Contact.updateContact(contact: contact) {
                        self.presentSingleActionAlertController(message: shouldAdd ? ActionSuccess.AddedContact.rawValue : ActionSuccess.EditedContact.rawValue)
                    } else {
                        self.presentSingleActionAlertController(message: ActionError.EditError.rawValue)
                    }
                }
            }))
            
            present(confirmAlertController, animated: true, completion: nil)
        }
    }

}

extension ContactActionsViewController {
    
    func presentSingleActionAlertController(message: String) {
        let alertController = UIAlertController.init(title: "Phonebook", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction.init(title: AlertControllerActions.Ok.rawValue, style: .cancel, handler: { (UIAlertAction) in
            if message == ActionSuccess.AddedContact.rawValue || message == ActionSuccess.EditedContact.rawValue {
                self.contactProtocol?.changeInContacts()
                
                _ = self.navigationController?.popViewController(animated: true)
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePhoneNumber(phoneNumber: String) -> Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(phoneNumber.characters).isSubset(of: nums)
    }
    
}
