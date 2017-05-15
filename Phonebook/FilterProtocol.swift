//
//  FilterProtocol.swift
//  Phonebook
//
//  Created by Viktor Georgiev on 5/14/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

import Foundation

protocol FilterProtocol {
    
    func filter(male     : Bool,
                female   : Bool,
                countryId: Int
    )
    
}
