//
//  ShelterInfoVC.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 11/11/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit
import MapKit

class ShelterInfoVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shelterNameLabel: UILabel!
    @IBOutlet weak var shelterEmailLabel: UILabel!
    @IBOutlet weak var shelterCityLabel: UILabel!
    @IBOutlet weak var shelterStateLabel: UILabel!
    @IBOutlet weak var shelterCountryLabel: UILabel!
    
    var shelter: Shelter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfos()
    }
    
    private func updateInfos() {
        shelterNameLabel.text = shelter.name?.trimmingCharacters(in: .whitespacesAndNewlines)
        shelterEmailLabel.text = shelter.email?.trimmingCharacters(in: .whitespacesAndNewlines)
        shelterCityLabel.text = shelter.city?.trimmingCharacters(in: .whitespacesAndNewlines)
        shelterStateLabel.text = shelter.state?.trimmingCharacters(in: .whitespacesAndNewlines)
        shelterCountryLabel.text = shelter.country?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        mapView.isUserInteractionEnabled = false
        let latitude = CLLocationDegrees(shelter.latitude)
        let longitude = CLLocationDegrees(shelter.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = CustomPinAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let latDelta: CLLocationDegrees = 1.5
        let lonDelta: CLLocationDegrees = 1.5
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
            pinView!.canShowCallout = false
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
