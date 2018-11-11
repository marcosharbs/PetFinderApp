//
//  MyPetsVC.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 11/11/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class MyPetsVC: UITableViewController {

    var pets: [Pet]?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPets()
    }
    
    private func loadPets() {
        PetFinderInteractor.instance.getFavoritePets() { pets in
            self.pets = pets
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
