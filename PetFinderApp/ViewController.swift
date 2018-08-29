//
//  ViewController.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 27/08/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PetClient.instance.getPets(location: "Blumenau, SC")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

