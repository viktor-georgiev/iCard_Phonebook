//
//  Contact.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/11/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import Foundation

class Contact {
    
    private var id  : Int!
    var firstname   : String!
    var lastname    : String!
    var countryId   : Int!
    var email       : String!
    var phoneNumber : Int!
    var genderId    : Int!
    
    init() {
        self.id          = -1
        self.firstname   = ""
        self.lastname    = ""
        self.countryId   = -1
        self.email       = ""
        self.phoneNumber = -1
        self.genderId    = -1
    }
    
    func setId(id: Int) {
        if self.id == -1 {
            self.id = id
        } else {
            print("Cannot change id")
        }
    }
    
    func getId() -> Int {
        return self.id
    }
    
}

extension Contact {
    
    static func addContact(contact: Contact) -> Bool {
        var added = false
        
        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
            guard database.open() else {
                return added
            }
            
            let manager = FMDBManager.sharedInstance
            let insertContactQuery = "INSERT INTO \(manager.table_Contacts) (\(manager.column_Contact_FirstName), \(manager.column_Contact_LastName), \(manager.column_Contact_Country), \(manager.column_Contact_Email), \(manager.column_Contact_PhoneNumber), \(manager.column_Contact_Gender)) VALUES (?, ?, ?, ?, ?, ?)"
            do {
                try database.executeUpdate(insertContactQuery, values: [contact.firstname, contact.lastname, contact.countryId, contact.email, contact.phoneNumber, contact.genderId])
                added = true
            } catch {
                print("Error inserting contact")
            }
        }
        
        return added
    }
    
    static func updateContact(contact: Contact) -> Bool {
        var updated = false
        
        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
            guard database.open() else {
                return updated
            }
            
            let manager = FMDBManager.sharedInstance
            let updateContactQuery = String.init(format: "UPDATE \(manager.table_Contacts) SET \(manager.column_Contact_FirstName) = '%@', \(manager.column_Contact_LastName) = '%@', \(manager.column_Contact_Country) = '%i', \(manager.column_Contact_Email) = '%@', \(manager.column_Contact_PhoneNumber) = '%i', \(manager.column_Contact_Gender) = '%i' WHERE \(manager.column_Contact_ID) = %i", contact.firstname, contact.lastname, contact.countryId, contact.email, contact.phoneNumber, contact.genderId, contact.getId())
            do {
                try database.executeUpdate(updateContactQuery, values: nil)
                updated = true
            } catch {
                print("Error inserting contact")
            }
        }
        
        return updated
    }
    
    static func deleteContact(id: Int) -> Bool {
        var deleted = false

        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
            guard database.open() else {
                return deleted
            }
            
            let manager = FMDBManager.sharedInstance
            let deleteContactQuery = "DELETE FROM \(manager.table_Contacts) WHERE \(manager.column_Contact_ID) = ?"
            do {
                try database.executeUpdate(deleteContactQuery, values: [id])
                deleted = true
            } catch {
                print("Error deleting contact")
            }
        }
        
        return deleted
    }
    
    static func filter(male      : Bool,
                       female    : Bool,
                       countryId : Int) -> [Contact] {
        var contactsArray = [Contact]()
        
        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
            guard database.open() else {
                return contactsArray
            }
            
            do {
                let manager = FMDBManager.sharedInstance
                var filterQuery = ""
                var result: FMResultSet!
                if (male || female) && countryId == -1 {
                    filterQuery = "SELECT * FROM \(manager.table_Contacts) WHERE \(manager.column_Contact_Gender) = ?"
                    result = try database.executeQuery(filterQuery, values: [(male ? 0 : 1)])
                } else if countryId != -1 && !male && !female {
                    filterQuery = "SELECT * FROM \(manager.table_Contacts) WHERE \(manager.column_Contact_Country) = ?"
                    result = try database.executeQuery(filterQuery, values: [countryId])
                } else {
                    filterQuery = "SELECT * FROM \(manager.table_Contacts) WHERE \(manager.column_Contact_Country) = ? AND \(manager.column_Contact_Gender) = ?"
                    result = try database.executeQuery(filterQuery, values: [countryId, (male ? 0 : 1)])
                }
                
                while result.next() {
                    let contact = Contact()
                    
                    contact.setId(id: Int(result.int(forColumn:     manager.column_Contact_ID)))
                    contact.firstname   = result.string(forColumn:  manager.column_Contact_FirstName)
                    contact.lastname    = result.string(forColumn:  manager.column_Contact_LastName)
                    contact.countryId   = Int(result.int(forColumn: manager.column_Contact_Country))
                    contact.email       = result.string(forColumn:  manager.column_Contact_Email)
                    contact.phoneNumber = Int(result.int(forColumn: manager.column_Contact_PhoneNumber))
                    contact.genderId    = Int(result.int(forColumn: manager.column_Contact_Gender))
                    
                    contactsArray.append(contact)
                }
            } catch {
                print("Failed to retrieve contacts information")
            }
        }
        
        return contactsArray
    }
    
    static func contactsList() -> [Contact] {
        var contactsArray = [Contact]()
        
        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
            guard database.open() else {
                return contactsArray
            }
            
            do {
                let manager = FMDBManager.sharedInstance
                let result = try database.executeQuery("SELECT * FROM \(manager.table_Contacts)", values: nil)
                while result.next() {
                    let contact = Contact()
                    
                    contact.setId(id: Int(result.int(forColumn:     manager.column_Contact_ID)))
                    contact.firstname   = result.string(forColumn:  manager.column_Contact_FirstName)
                    contact.lastname    = result.string(forColumn:  manager.column_Contact_LastName)
                    contact.countryId   = Int(result.int(forColumn: manager.column_Contact_Country))
                    contact.email       = result.string(forColumn:  manager.column_Contact_Email)
                    contact.phoneNumber = Int(result.int(forColumn: manager.column_Contact_PhoneNumber))
                    contact.genderId    = Int(result.int(forColumn: manager.column_Contact_Gender))
                    
                    contactsArray.append(contact)
                }
            } catch {
                print("Failed to retrieve contacts information")
            }
        }
        
        return contactsArray
    }
        
}
