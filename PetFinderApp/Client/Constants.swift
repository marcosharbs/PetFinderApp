//
//  Constants.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 27/08/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

struct Constants {
    
    struct PetFinderApi {
        
        static let API_HOST = "http://api.petfinder.com"
        static let API_KEY = "a1bee8e17cd04315301029a23a64f8f6"
        static let OUTPUT_FORMAT = "json"
        
        struct Methods {
            static let PET_FIND = "pet.find"
            static let SHELTER_GET = "shelter.get"
            static let PET_GET = "pet.get"
        }
        
        struct Params {
            static let KEY = "key"
            static let FORMAT = "format"
            static let ID = "id"
            static let LOCATION = "location"
        }
        
        struct Response {
            static let PETFINDER = "petfinder"
            static let HEADER = "header"
            static let STATUS = "status"
            static let MESSAGE = "message"
            static let CODE = "code"
            static let PETS = "pets"
            static let PET = "pet"
        }
        
    }
    
}
