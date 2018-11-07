//
//  Pet.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 27/08/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

struct PetApi : Codable {
    
    let id: StringApi?
    let age: StringApi?
    let size: StringApi?
    let shelterId: StringApi?
    let name: StringApi?
    let sex: StringApi?
    let description: StringApi?
    let mix: StringApi?
    let animal: StringApi?
    let media: MediaApi?
    let breeds: BreedsApi?
    
}
