//
//  PetDetailVC.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 11/11/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class PetDetailVC: UIViewController {
    
    var pet: Pet!
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petDescriptionTextView: UITextView!
    @IBOutlet weak var petFavoriteButton: UIButton!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var petSexLabel: UILabel!
    @IBOutlet weak var petBreedLabel: UILabel!
    
    override func viewDidLoad() {
        updateView()
    }
    
    private func updateView() {
        let photos = pet!.photos?.allObjects as! [Photo]
        
        if(photos.count > 0) {
            var photo:Photo? = nil
            
            var index = 0
            
            while photo == nil {
                if(photos[index].size == "x") {
                    photo = photos[index]
                }
                index = index + 1
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            PetFinderInteractor.instance.getPhotoPicture(photo: photo!) {picture, error in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.petImageView.image = UIImage(data: picture!)
            }
        }
        
        petDescriptionTextView.text = pet.petDescription
        petNameLabel.text = pet.name
        petAgeLabel.text = pet.age
        petSexLabel.text = pet.sex
        petBreedLabel.text = pet.breed
        
        if pet.favorite {
           petFavoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            petFavoriteButton.setImage(UIImage(named: "unfavorite"), for: .normal)
        }
    }
    
    @IBAction func favoritePet(_ sender: Any) {
        if pet.favorite {
            PetFinderInteractor.instance.unfavoritePet(pet: pet)
            petFavoriteButton.setImage(UIImage(named: "unfavorite"), for: .normal)
        } else {
            PetFinderInteractor.instance.favoritePet(pet: pet)
            petFavoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        }
    }
    
    @IBAction func onShelterInfo(_ sender: Any) {
        let shelterInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "ShelterInfoVC") as! ShelterInfoVC
        shelterInfoVC.shelter = pet.shelter
        
        self.navigationController?.pushViewController(shelterInfoVC, animated: true)
    }
    
}
