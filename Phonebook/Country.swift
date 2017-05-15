//
//  Country.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import Foundation

class Country {
    
    private var id : Int!
    var name       : String!
    var code       : Int!
    
    init() {
        self.id   = -1
        self.name = ""
        self.code = -1
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

extension Country {
    
    static func getCountryById(id: Int) -> Country {
        let country = Country()
        
        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
            guard database.open() else {
                return country
            }
            
            do {
                let manager = FMDBManager.sharedInstance
                let result = try database.executeQuery("SELECT * FROM \(manager.table_Countries) WHERE \(manager.column_Country_ID) = ?", values: [id])
                if result.next() {
                    country.setId(id: Int(result.int(forColumn: manager.column_Country_ID)))
                    country.name = result.string(forColumn: manager.column_Country_Name)
                    country.code = Int(result.int(forColumn: manager.column_Country_PhoneCode))
                }
            } catch {
                print("Failed to retrieve countries information")
            }
        }
        
        return country
    }
    
    static func countriesList() -> [Country] {
        var countriesArray = NSArray.init() as! [Country]
        
        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
            guard database.open() else {
                return countriesArray
            }
            
            do {
                let result = try database.executeQuery("SELECT * FROM \(FMDBManager.sharedInstance.table_Countries)", values: nil)
                while result.next() {
                    let country = Country()
                    
                    country.setId(id: Int(result.int(forColumn: FMDBManager.sharedInstance.column_Country_ID)))
                    country.name = result.string(forColumn: FMDBManager.sharedInstance.column_Country_Name)
                    country.code = Int(result.int(forColumn: FMDBManager.sharedInstance.column_Country_PhoneCode))
                    
                    countriesArray.append(country)
                }
            } catch {
                print("Failed to retrieve countries information")
            }
        }
        
        return countriesArray
    }
    
    static func insertCountriesDataInDB() {
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! NSDictionary
                    if let people : [NSDictionary] = jsonResult["countries"] as? [NSDictionary] {
                        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
                            guard database.open() else {
                                return
                            }
                            
                            let manager = FMDBManager.sharedInstance
                            let insertCountryQuery = "INSERT INTO \(manager.table_Countries) (\(manager.column_Country_Name), \(manager.column_Country_PhoneCode)) VALUES (?, ?)"
                            for person: NSDictionary in people {
                                do {
                                    try database.executeUpdate(insertCountryQuery, values: [person.object(forKey: "name")!, person.object(forKey: "code")!])
                                } catch {
                                    print("Failed inserting \(person.object(forKey: "name"))")
                                }
                            }
                        }
                    }
                } catch {
                    print("Could not load json from file")
                }
            } catch {
                print("File not found")
            }
        }
    }

}
