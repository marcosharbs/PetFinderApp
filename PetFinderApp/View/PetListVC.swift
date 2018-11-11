//
//  PetListVC.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 11/11/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class PetListVC: UITableViewController {
    
    var pin: Pin!
    var pets: [Pet]?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPets()
    }
    
    private func loadPets() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        PetFinderInteractor.instance.getPets(pin: self.pin) { pets, error in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard error == nil else {
                self.showError(error! as NSError)
                return
            }
            
            self.pets = pets?.allObjects as? [Pet]
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pets?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell")!
        let pet = self.pets?[(indexPath as NSIndexPath).row]
        
        if pet != nil {
            let photos = pet!.photos?.allObjects as! [Photo]
            
            if(photos.count > 0) {
                PetFinderInteractor.instance.getPhotoPicture(photo: photos[0]) {picture, error in
                    cell.imageView?.image = UIImage(data: picture!)
                }
            }
            
            cell.textLabel?.text = pet!.name
            cell.detailTextLabel?.text = pet!.breed
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = self.pets?[indexPath.row]
        
        let petDetailtVC = self.storyboard!.instantiateViewController(withIdentifier: "PetDetailVC") as! PetDetailVC
        petDetailtVC.pet = pet
        
        self.navigationController?.pushViewController(petDetailtVC, animated: true)
    }
    
}
