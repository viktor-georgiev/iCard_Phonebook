//
//  FMDBManager.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import UIKit

class FMDBManager: NSObject {

    //singleton
    static let sharedInstance      : FMDBManager = FMDBManager()
    
    var database                   : FMDatabase!
    
    var databseFilePath            : String!
    
    // Countries table
    let table_Countries            = "Countries"
    
    let column_Country_ID          = "ID"
    let column_Country_Name        = "name"
    let column_Country_PhoneCode   = "phonecode"
    
    // Contacts table
    let table_Contacts             = "Contacts"
    
    let column_Contact_ID          = "ID"
    let column_Contact_FirstName   = "firstname"
    let column_Contact_LastName    = "lastname"
    let column_Contact_Country     = "country"
    let column_Contact_Email       = "email"
    let column_Contact_PhoneNumber = "phone_number"
    let column_Contact_Gender      = "gender"
    
    // Genders table
    let table_Genders              = "Genders"
    
    let column_Gender_ID           = "ID"
    let column_Gender_Type         = "gender"
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        databseFilePath = documentsDirectory.appending("/phonebook.sqlite")
    }
    
    //creates database with the given name if it does not exist
    func instantiateDatabase() -> Bool {
        var didCreateDb = false
        
        if !FileManager.default.fileExists(atPath: databseFilePath) {
            database = FMDatabase(path: databseFilePath!)
            
            if database != nil {
                guard database.open() else {
                    return didCreateDb
                }
                
                didCreateDb = createTables()
                    
                database.close()
            }
        }
        
        return didCreateDb
    }
    
}

private extension FMDBManager {
    
    //creates the tables in db
    func createTables() -> Bool {
        let createCountriesTableQuery = "CREATE TABLE \(table_Countries) (\(column_Country_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(column_Country_Name) TEXT NOT NULL, \(column_Country_PhoneCode) INTEGER NOT NULL)"
        
        let createGendersTableQuery = "CREATE TABLE \(table_Genders) (\(column_Gender_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(column_Gender_Type) TEXT NOT NULL)"
        
        let createContactsTableQuery = "CREATE TABLE \(table_Contacts) (\(column_Contact_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(column_Contact_FirstName) TEXT NOT NULL, \(column_Contact_LastName) TEXT NOT NULL, \(column_Contact_Country) INTEGER NOT NULL, \(column_Contact_Email) TEXT NOT NULL, \(column_Contact_PhoneNumber) TEXT NOT NULL, \(column_Contact_Gender) INTEGER NOT NULL, FOREIGN KEY (\(column_Contact_Country)) REFERENCES \(table_Countries)(\(column_Country_ID)), FOREIGN KEY (\(column_Contact_Gender)) REFERENCES \(table_Genders)(\(column_Gender_Type)))"
        
        do {
            try database.executeUpdate(createCountriesTableQuery, values: nil)
            try database.executeUpdate(createGendersTableQuery  , values: nil)
            try database.executeUpdate(createContactsTableQuery , values: nil)

            return true
        }
        catch {
            return false
        }
    }
    
}
