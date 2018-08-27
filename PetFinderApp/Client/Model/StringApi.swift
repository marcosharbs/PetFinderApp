//
//  StringWrap.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 27/08/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

struct StringApi : Codable {
    
    let value: String
    
    enum CodingKeys : String, CodingKey {
        case value = "$t"
    }
    
}
