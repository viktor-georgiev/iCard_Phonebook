//
//  ContactsViewController.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class ContactsViewController: BasicViewController, UITableViewDataSource, UITableViewDelegate, ContactProtocol, FilterProtocol {

    //MARK: Variables
    
    private var contactsArray            : [Contact]!
    
    private var contactToEdit            : Contact?
    private var contactForInfo           : Contact?
    
    private var filter_ByMale            : Bool!
    private var filter_ByFemale          : Bool!
    
    private var filter_ByCountry         : Int!
    
    
    //MARK: Outlets
    
    @IBOutlet weak var contactsTableView : UITableView!
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupInitialFilters()
    
        loadContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Navigation Functions
    
    func setupNavigationBar() {
        navigationItem.title = ViewControllerTitles.Contacts.rawValue
        
        let leftButton = UIBarButtonItem(
            image: UIImage.init(named: "icon_filter"),
            style: .plain,
            target: self,
            action: #selector(navigateToFilters(sender:))
        )
        
        let rightButton = UIBarButtonItem(
            title: NavigationItemTitles.Add.rawValue,
            style: .plain,
            target: self,
            action: #selector(navigateToRegistrationForm(sender:))
        )
        
        navigationItem.leftBarButtonItem  = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func navigateToRegistrationForm(sender: UIBarButtonItem) {
        self.performSegue(
            withIdentifier: SegueIdentifiers.AddContactSegue.rawValue,
            sender: self
        )
    }
    
    func navigateToFilters(sender: UIBarButtonItem) {
        self.performSegue(
            withIdentifier: SegueIdentifiers.FiltersSegue.rawValue,
            sender: self
        )
    }
    
    
    //MARK: Custom Functions
    
    func setupInitialFilters() {
        filter_ByMale    = false
        filter_ByFemale  = false
        filter_ByCountry = -1
    }
    
    //load contacts from database
    func loadContacts() {
        contactsArray = Contact.contactsList()
        contactsTableView.reloadData()
        
        checkContactsCount()
    }
    
    //shows and hides the filter button
    func checkContactsCount() {
        if contactsArray.count == 0 {
            navigationItem.leftBarButtonItem = nil
        } else {
            setupNavigationBar()
        }
    }
    
    
    //MARK: Custom Protocol Functions
    
    func changeInContacts() {
        loadContacts()
    }
    
    func filter(male      : Bool,
                female    : Bool,
                countryId : Int) {
        
        filter_ByMale     = male
        filter_ByFemale   = female
        filter_ByCountry  = countryId
        
        if male || female || countryId != -1 {
            contactsArray = Contact.filter(
                male      : filter_ByMale,
                female    : filter_ByFemale,
                countryId : filter_ByCountry
            )
            contactsTableView.reloadData()
        } else {
            loadContacts()
        }
    }
    
    
    //MARK: Table View Data Source and Delegate Functions
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.contactsArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell    = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ContactCell.rawValue)! as! ContactTableViewCell
        let contact = self.contactsArray[indexPath.row]
        
        cell.contactNameLabel?.text = String.init(format: "%@ %@", contact.firstname, contact.lastname)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action , indexPath ) -> Void in
            self.contactToEdit = self.contactsArray[indexPath.row]
            
            self.performSegue(
                withIdentifier: SegueIdentifiers.EditContactSegue.rawValue,
                sender: self
            )
            
            self.contactsTableView.reloadData()
            
        }
        editAction.backgroundColor = UIColor.lightGray
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action , indexPath) -> Void in
            let index = indexPath.row
            if Contact.deleteContact(id: self.contactsArray[index].getId()) {
                self.contactsArray.remove(at: index)
                self.contactsTableView.reloadData()
                self.checkContactsCount()
            }
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(
            at       : indexPath,
            animated : true
        )
        
        contactForInfo = self.contactsArray[indexPath.row]
        self.performSegue(withIdentifier: SegueIdentifiers.ContactInformationSegue.rawValue, sender: self)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if let addContactViewController = segue.destination as? AddContactViewController {
            addContactViewController.contactProtocol  = self
        } else if let editContactViewController = segue.destination as? EditContactViewController {
            editContactViewController.contactProtocol = self
            editContactViewController.contact         = self.contactToEdit
            self.contactToEdit                        = nil
        } else if let filtersViewController = segue.destination as? FiltersViewController {
            filtersViewController.filterProtocol      = self
            filtersViewController.filter_ByMale       = filter_ByMale
            filtersViewController.filter_ByFemale     = filter_ByFemale
            filtersViewController.filter_ByCountry    = filter_ByCountry
        } else if let contactInfoViewController = segue.destination as? ContactInformationViewController {
            contactInfoViewController.contact         = self.contactForInfo
            self.contactForInfo                       = nil
        }
    }

}
