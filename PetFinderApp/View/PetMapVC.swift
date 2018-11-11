//
//  ViewController.swift
//  PetFinderApp
//
//  Created by Marcos Harbs on 27/08/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit
import MapKit

class PetMapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureRegion()
        self.fetchPins()
    }
    
    func fetchPins() {
        PetFinderInteractor.instance.getPins() { pins in
            for pin in pins {
                self.addPointToMap(pin)
            }
        }
    }
    
    func addPointToMap(_ pin: Pin) {
        let latitude = CLLocationDegrees(pin.x)
        let longitude = CLLocationDegrees(pin.y)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = CustomPinAnnotation()
        annotation.coordinate = coordinate
        annotation.pin = pin
        self.mapView.addAnnotation(annotation)
    }

    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            let location = sender.location(in: self.mapView)
            let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
            
            let pin = PetFinderInteractor.instance.createPin(latitude: Float(coordinate.latitude), longitude: Float(coordinate.longitude))
  
            self.addPointToMap(pin)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveRegion()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
            pinView!.canShowCallout = false
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = (view.annotation as! CustomPinAnnotation).pin

        let petListVC = self.storyboard!.instantiateViewController(withIdentifier: "PetListVC") as! PetListVC
        petListVC.pin = pin

        self.navigationController?.pushViewController(petListVC, animated: true)
    }
    
    func saveRegion() {
        PetFinderInteractor.instance.saveMapRegion(centerLatitude: Double(self.mapView.region.center.latitude), centerLongitude: Double(self.mapView.region.center.longitude), spanLatitude: Double(self.mapView.region.span.latitudeDelta), spanLongitude: Double(self.mapView.region.span.longitudeDelta))
    }
    
    func configureRegion() {
        let region = PetFinderInteractor.instance.getMapRegion()
        
        let centerLatitude = CLLocationDegrees(exactly: region["centerLatitude"]!)
        let centerLongitude = CLLocationDegrees(exactly: region["centerLongitude"]!)
        let spanLatitude = CLLocationDegrees(exactly: region["spanLatitude"]!)
        let spanLongitude = CLLocationDegrees(exactly: region["spanLongitude"]!)

        let center = CLLocationCoordinate2D(latitude: centerLatitude!, longitude: centerLongitude!)
        let span = MKCoordinateSpan(latitudeDelta: spanLatitude!, longitudeDelta: spanLongitude!)
        let mapRegion = MKCoordinateRegion(center: center, span: span)
        self.mapView.region = mapRegion
    }

}

