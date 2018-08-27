//
//  PhotoApi.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 27/08/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

struct PhotoApi : Codable {
    
    let id: String
    let size: String
    let url: String
    
    enum CodingKeys : String, CodingKey {
        case id = "@id"
        case size = "@size"
        case url = "$t"
    }
    
}
