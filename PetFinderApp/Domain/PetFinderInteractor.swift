//
//  PetFinderInteractor.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 10/11/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import CoreData
import CoreLocation

class PetFinderInteractor {
    
    static let instance = PetFinderInteractor()
    
    var dataController: DataController!
    
    func saveMapRegion(centerLatitude: Double, centerLongitude: Double, spanLatitude: Double, spanLongitude: Double) {
        UserDefaults.standard.set(centerLatitude, forKey: "center.latitude")
        UserDefaults.standard.set(centerLongitude, forKey: "center.longitude")
        UserDefaults.standard.set(spanLatitude, forKey: "span.latitude")
        UserDefaults.standard.set(spanLongitude, forKey: "span.longitude")
    }
    
    func getMapRegion() -> Dictionary<String, Double> {
        UserDefaults.standard.register(defaults: [
            "center.latitude" : Double(41.178505992902245),
            "center.longitude" : Double(-99.769122436002334),
            "span.latitude" : Double(41.412703443823474),
            "span.longitude" : Double(34.721575491666286)
            ])
        
        let centerLatitude = UserDefaults.standard.double(forKey: "center.latitude")
        let centerLongitude = UserDefaults.standard.double(forKey: "center.longitude")
        let spanLatitude = UserDefaults.standard.double(forKey: "span.latitude")
        let spanLongitude = UserDefaults.standard.double(forKey: "span.longitude")

        return [
            "centerLatitude" : centerLatitude,
            "centerLongitude" : centerLongitude,
            "spanLatitude" : spanLatitude,
            "spanLongitude" : spanLongitude
        ]
    }
    
    func getPins(completionHandler: @escaping (_ pins: [Pin]) -> Void) {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let pins = try? dataController.viewContext.fetch(fetchRequest) {
            completionHandler(pins)
        }
    }
    
    func createPin(latitude: Float, longitude: Float) -> Pin {
        let pin = Pin(context: dataController.viewContext)
        pin.x = Float(latitude)
        pin.y = Float(longitude)
        try? dataController.viewContext.save()
        return pin
    }
    
    func favoritePet(pet: Pet) {
        pet.favorite = true
        try? dataController.viewContext.save()
    }
    
    func unfavoritePet(pet: Pet) {
        pet.favorite = false
        try? dataController.viewContext.save()
    }
    
    func getFavoritePets(completionHandler: @escaping (_ pets: [Pet]) -> Void) {
        let fetchRequest: NSFetchRequest<Pet> = Pet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favorite == YES")
        if let pets = try? dataController.viewContext.fetch(fetchRequest) {
            completionHandler(pets)
        }
    }
    
    func getPhotoPicture(photo: Photo, completionHandler: @escaping (_ picture: Data?, _ error: Error?) -> Void) {
        if photo.picture != nil {
            completionHandler(photo.picture!, nil)
        } else {
            let task = URLSession.shared.dataTask(with: URL(string: photo.url!)!) { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        photo.picture = data
                        try? self.dataController.viewContext.save()
                        completionHandler(data!, nil)
                    }
                } else {
                    completionHandler(nil, error)
                }
            }
            task.resume()
        }
    }
    
    func getPets(pin: Pin, completionHandler: @escaping (_ pets: NSSet?, _ error: Error?) -> Void) {
        if pin.pets?.count ?? 0 > 0 {
            completionHandler(pin.pets, nil)
        } else {
            var center = CLLocationCoordinate2D()
            center.latitude = Double("\(pin.x)")!
            center.longitude = Double("\(pin.y)")!
   
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude:center.latitude, longitude: center.longitude)) { placemarks, error in
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                
                guard placemarks?.count ?? 0 > 0 else {
                    completionHandler(nil, NSError(domain: "/getPets", code: 0, userInfo: [NSLocalizedDescriptionKey: "Problem with the data received from geocoder!"]))
                    return
                }
                
                PetClient.instance.getPets(location: placemarks![0].postalCode!) { petsApi, error in
                    guard error == nil else {
                        completionHandler(nil, error)
                        return
                    }
                    
                    if let petsApi = petsApi?.pet {
                        
                        var requestCount = 0;
                        
                        for petApi in petsApi {
                            PetClient.instance.getShelter(id: petApi.shelterId?.value ?? "") { shelterApi, error in
                                
                                requestCount = requestCount + 1
                                
                                guard (error == nil) else {
                                    completionHandler(nil, error)
                                    return
                                }
                                
                                let shelter = Shelter(context: self.dataController.viewContext)
                                shelter.address1 = shelterApi?.address1?.value ?? ""
                                shelter.city = shelterApi?.city?.value ?? ""
                                shelter.country = shelterApi?.country?.value ?? ""
                                shelter.email = shelterApi?.email?.value ?? ""
                                shelter.id = shelterApi?.id?.value ?? ""
                                shelter.latitude = Double(shelterApi?.latitude?.value ?? "0.0") ?? 0.0
                                shelter.longitude = Double(shelterApi?.longitude?.value ?? "0.0") ?? 0.0
                                shelter.name = shelterApi?.name?.value ?? ""
                                shelter.state = shelterApi?.state?.value ?? ""
                                shelter.zip = shelterApi?.zip?.value ?? ""
                                
                                let pet = Pet(context: self.dataController.viewContext)
                                pet.age = petApi.age?.value ?? ""
                                pet.animal = petApi.animal?.value ?? ""
                                
                                switch petApi.breeds?.breed {
                                case .array(let breeds)?:
                                    pet.breed = breeds[0].value ?? ""
                                case .string(let breed)?:
                                    pet.breed = breed.value ?? ""
                                case .none:
                                    pet.breed = ""
                                }
                                
                                pet.favorite = false
                                pet.id = petApi.id?.value ?? ""
                                pet.mix = petApi.mix?.value ?? ""
                                pet.name = petApi.name?.value ?? ""
                                pet.petDescription = petApi.description?.value ?? ""
                                pet.sex = petApi.sex?.value ?? ""
                                pet.size = petApi.size?.value ?? ""
                                pet.shelter = shelter
                                pet.pin = pin
                                
                                for photoApi in petApi.media?.photos?.photo ?? [] {
                                    let photo = Photo(context: self.dataController.viewContext)
                                    photo.id = photoApi.id ?? ""
                                    photo.size = photoApi.size ?? ""
                                    photo.url = photoApi.url ?? ""
                                    photo.pet = pet
                                    
                                    pet.addToPhotos(photo)
                                }
                                
                                pin.addToPets(pet)
                                
                                try? self.dataController.viewContext.save()
                                
                                if requestCount == petsApi.count {
                                    completionHandler(pin.pets, nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
