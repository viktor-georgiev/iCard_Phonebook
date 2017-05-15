//
//  AddContactViewController.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/11/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class AddContactViewController: ContactActionsViewController, UITextFieldDelegate, CountryProtocol {
    
    //MARK: Variables
    
    private var chosenCountry                   : Country?
    
    
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

        chosenCountry = Country()
        
        setupNavigationBar()
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
    
    //MARK: Navigation Functions
    
    func setupNavigationBar() {
        navigationItem.title = ViewControllerTitles.NewContact.rawValue
        
        let leftButton = UIBarButtonItem(
            title: NavigationItemTitles.Cancel.rawValue,
            style: .plain,
            target: self,
            action: #selector(super.popController)
        )
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(
            title: NavigationItemTitles.Confirm.rawValue,
            style: .plain,
            target: self,
            action: #selector(onConfirmPressed(sender:))
        )
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func didChooseCountry(country: Country) {
        chosenCountry = country
        button_ChooseCountry.setTitle(country.name, for: .normal)
        label_CountryCode.text = String.init(format: "+ %d", country.code)
    }
    
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
    
    func onConfirmPressed(sender: UIBarButtonItem) {
        let firstname       = textField_FirstName.text!
        let lastname        = textField_LastName.text!
        let countryId       = chosenCountry?.getId()
        let email           = textField_Email.text!
        let phoneNumberText = textField_PhoneNumber.text!
        let genderId        = segmentControl_Gender.selectedSegmentIndex
        
        super.contactAction(
            shouldAdd       : true,
            contact         : Contact(),
            firstname       : firstname,
            lastname        : lastname,
            countryId       : countryId!,
            email           : email,
            phoneNumberText : phoneNumberText,
            genderId        : genderId
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

extension AddContactViewController {
    
//    func presentSingleActionAlertController(message: String) {
//        let alertController = UIAlertController.init(title: "Phonebook", message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alertController.addAction(UIAlertAction.init(title: AlertControllerActions.Ok.rawValue, style: .cancel, handler: { (UIAlertAction) in
//            if message == "Contact added succesfully" {
//                self.contactProtocol?.changeInContacts()
//                
//                _ = self.navigationController?.popViewController(animated: true)
//            }
//        }))
//        
//        present(alertController, animated: true, completion: nil)
//    }
    
}
