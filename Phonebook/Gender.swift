//
//  Gender.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/15/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import Foundation

class Gender {
    
    private var id : Int!
    var type       : String!
    
    init() {
        self.id   = -1
        self.type = ""
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

extension Gender {
    
    static func getGenderById(id: Int) -> Gender {
        let gender = Gender()
        
        if let database = FMDatabase(path: FMDBManager.sharedInstance.databseFilePath!) {
            guard database.open() else {
                return gender
            }
            
            do {
                let manager = FMDBManager.sharedInstance
                let result = try database.executeQuery("SELECT * FROM \(manager.table_Genders) WHERE \(manager.column_Gender_ID) = ?", values: [id])
                if result.next() {
                                        
                }
            } catch {
                print("Failed to retrieve countries information")
            }
        }
        
        return gender
    }
    
}
