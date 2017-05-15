//
//  AddContactViewController.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/11/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class EditContactViewController: ContactActionsViewController, UITextFieldDelegate, CountryProtocol {
    
    
    //MARK: Variables
    
    var contact                                 : Contact!
    
    private var chosenCountry                   : Country!
    
    
    //MARK: Outlets
    
    @IBOutlet weak var scrollView_ContactFields : UIScrollView!
    
    
    @IBOutlet weak var textField_FirstName      : UITextField!
    @IBOutlet weak var textField_LastName       : UITextField!
    @IBOutlet weak var textField_PhoneNumber    : UITextField!
    @IBOutlet weak var textField_Email          : UITextField!
    
    @IBOutlet weak var label_CountryCode        : UILabel!
    
    @IBOutlet weak var button_ChooseCountry     : UIButton!
    
    @IBOutlet weak var segmentControl_Gender    : UISegmentedControl!
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector : #selector(keyboardWillHide(notification:)),
            name     : .UIKeyboardWillHide,
            object   : nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(
            self,
            name   : .UIKeyboardWillShow,
            object : nil)
        
        notificationCenter.removeObserver(
            self,
            name   : .UIKeyboardWillHide,
            object : nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Navigation Functions
    
    func setupNavigationBar() {
        navigationItem.title = ViewControllerTitles.EditContact.rawValue
        
        let leftButton = UIBarButtonItem(
            title: NavigationItemTitles.Cancel.rawValue,
            style: .plain,
            target: self,
            action: #selector(super.popController)
        )
        
        let rightButton = UIBarButtonItem(
            title: NavigationItemTitles.Save.rawValue,
            style: .plain,
            target: self,
            action: #selector(onSavePressed(sender:))
        )
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
    //MARK: Custom Functions
    
    func setupContent() {
        textField_FirstName.text   = contact.firstname
        textField_LastName.text    = contact.lastname
        textField_PhoneNumber.text = String.init(format: "%d", contact.phoneNumber)
        textField_Email.text       = contact.email
        
        segmentControl_Gender.selectedSegmentIndex = contact.genderId
        
        if contact.countryId != -1 {
            setupCountry(country: Country.getCountryById(id: contact.countryId))
        } else {
            chosenCountry = Country()
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        var contentInset : UIEdgeInsets = self.scrollView_ContactFields.contentInset
        contentInset.bottom = keyboardHeight
        self.scrollView_ContactFields.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var contentInset : UIEdgeInsets = self.scrollView_ContactFields.contentInset
        contentInset.bottom = 0
        self.scrollView_ContactFields.contentInset = contentInset
        
    }
    
    func setupCountry(country: Country) {
        chosenCountry          = country
        label_CountryCode.text = String.init(format: "+ %d", chosenCountry.code)
        button_ChooseCountry.setTitle(chosenCountry.name, for: .normal)
    }
    
    //MARK: Custom Delegate Functions
    
    func didChooseCountry(country: Country) {
        setupCountry(country: country)
    }
    
    //MARK: TextField Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField_FirstName {
            textField_LastName.becomeFirstResponder()
        } else if textField == textField_LastName {
            textField_PhoneNumber.becomeFirstResponder()
        } else if textField == textField_PhoneNumber {
            textField_Email.becomeFirstResponder()
        } else if textField == textField_Email {
            textField_Email.resignFirstResponder()
        }
        
        return true
    }
    
    func onSavePressed(sender: UIBarButtonItem) {
        let firstname       = textField_FirstName.text!
        let lastname        = textField_LastName.text!
        let countryId       = chosenCountry.getId()
        let email           = textField_Email.text!
        let phoneNumberText = textField_PhoneNumber.text!
        let genderId        = segmentControl_Gender.selectedSegmentIndex
        
        super.contactAction(
            shouldAdd      : false,
            contact        : self.contact,
            firstname      : firstname,
            lastname       : lastname,
            countryId      : countryId,
            email          : email,
            phoneNumberText: phoneNumberText,
            genderId       : genderId
        )
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if let countriesController = segue.destination as? CountriesViewController {
            countriesController.countryProtocol = self
        }
    }
    
}
