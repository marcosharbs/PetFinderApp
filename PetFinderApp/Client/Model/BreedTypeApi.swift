//
//  BreedTypeApi.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 06/11/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

enum BreedTypeApi : Codable {
    case array([StringApi])
    case string(StringApi)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .array(container.decode(Array.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .string(container.decode(StringApi.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(BreedTypeApi.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .array(let array):
            try container.encode(array)
        case .string(let string):
            try container.encode(string)
        }
    }
}
