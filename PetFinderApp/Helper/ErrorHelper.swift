//
//  ErrorHelper.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 11/11/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(_ error: NSError) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
