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
    
    public func getPets(location: String, completionHandler: @escaping (_ pets: PetsApi?, _ error: Error?) -> Void) {
        let request = getRequest(method: Constants.PetFinderApi.Methods.PET_FIND, parameters: [
                Constants.PetFinderApi.Params.LOCATION: location as AnyObject
            ])
        
        self.sendRequest(request, PetsApi.self, Constants.PetFinderApi.Response.PETS, completionHandler)
    }
    
    public func getPet(id: String, completionHandler: @escaping (_ pets: PetApi?, _ error: Error?) -> Void) {
        let request = getRequest(method: Constants.PetFinderApi.Methods.PET_GET, parameters: [
            Constants.PetFinderApi.Params.ID: id as AnyObject
            ])
        
        self.sendRequest(request, PetApi.self, Constants.PetFinderApi.Response.PET, completionHandler)
    }
    
    public func getShelter(id: String, completionHandler: @escaping (_ pets: ShelterApi?, _ error: Error?) -> Void) {
        let request = getRequest(method: Constants.PetFinderApi.Methods.SHELTER_GET, parameters: [
            Constants.PetFinderApi.Params.ID: id as AnyObject
            ])
        
        self.sendRequest(request, ShelterApi.self, Constants.PetFinderApi.Response.SHELTER, completionHandler)
    }
    
    private func sendRequest<T>(_ request: NSMutableURLRequest, _ type: T.Type, _ responseKey: String, _ completionHandler: @escaping (_ data: T?, _ error: Error?) -> Void) -> Void where T: Decodable {
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            do {
                let parsedJson = try self.parseData(data!)
                let petfinderDic = parsedJson[Constants.PetFinderApi.Response.PETFINDER] as! [String:AnyObject]
                
                let requestError = self.getRequestError(petfinderDic)
                guard (requestError == nil) else {
                    DispatchQueue.main.async {
                        completionHandler(nil, requestError)
                    }
                    return
                }
                
                let dataDic = petfinderDic[responseKey] as! [String:AnyObject]
                let dataObject = try self.parseJson(dataDic, type)
                
                DispatchQueue.main.async {
                    completionHandler(dataObject, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    private func getRequestError(_ dictionary: [String:AnyObject]) -> NSError? {
        let headerDic = dictionary[Constants.PetFinderApi.Response.HEADER] as! [String:AnyObject]
        let statusDic = headerDic[Constants.PetFinderApi.Response.STATUS] as! [String:AnyObject]
        let codeDic = statusDic[Constants.PetFinderApi.Response.CODE] as! [String:AnyObject]
        let code = codeDic[Constants.PetFinderApi.Response.TEXT] as! String
        
        if(code != Constants.PetFinderApi.Response.CODE_STATUS_OK) {
            let messageDic = statusDic[Constants.PetFinderApi.Response.MESSAGE] as! [String:AnyObject]
            let message = messageDic[Constants.PetFinderApi.Response.TEXT]
            
            return NSError(domain: Constants.PetFinderApi.Methods.SHELTER_GET, code: Int(code)!, userInfo: [NSLocalizedDescriptionKey: message ?? ""])
        }
        
        return nil
    }
    
    private func parseData(_ data: Data) throws -> [String:AnyObject] {
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
    }
    
    private func parseJson<T>(_ dictionary: [String:AnyObject], _ type: T.Type) throws -> T where T : Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return try JSONDecoder().decode(type, from: jsonData)
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
