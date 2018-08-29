//
//  PetClient.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 27/08/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import Foundation

class PetClient {
    
    static let instance = PetClient()
    
    let session = URLSession.shared
    
    public func getPets(location: String) {
        let request = getRequest(method: Constants.PetFinderApi.Methods.PET_FIND, parameters: [
                Constants.PetFinderApi.Params.LOCATION: location as AnyObject
            ])
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            print(data ?? "")
            print(response ?? "")
            print(error ?? "")
        }
        
        task.resume()
    }
    
    private func getRequest(method: String, parameters: [String:AnyObject]) -> NSMutableURLRequest {
        var parameters = parameters
        parameters[Constants.PetFinderApi.Params.KEY] = Constants.PetFinderApi.API_KEY as AnyObject
        parameters[Constants.PetFinderApi.Params.FORMAT] = Constants.PetFinderApi.OUTPUT_FORMAT as AnyObject
        return NSMutableURLRequest(url: self.getUrl(method, parameters))
    }
    
    private func getUrl(_ method: String, _ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.PetFinderApi.API_SCHEME
        components.host = Constants.PetFinderApi.API_HOST
        components.path = method
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
}
