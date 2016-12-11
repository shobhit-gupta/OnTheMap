//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 07/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var otmNavigationItemController: OTMNavigationItemController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createOTMNavigationItemController(&otmNavigationItemController)
        //showOTMAnnotations()
        testWithRandomAnnotations()
    }
    
}


extension MapViewController: OTMNavigationItemControllerProtocol {}


extension MapViewController {
    
    func showOTMAnnotations() {
        displayAnnotations(createOTMAnnotations())
    }
    
    
    func displayAnnotations(_ annotations: [MKAnnotation]) {
        mapView.showAnnotations(annotations, animated: true)
    }
    
    
    func createOTMAnnotations() -> [OTMMapViewAnnotation] {
        let annotations = OTMMapViewAnnotation.getOTMMapViewAnnotations(with: [
            [.title: "Delhi",
             .subtitle: "Asia’s Largest Wholesale Spice Market",
             .coordinate: CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)],
            
            [.title: "London",
             .subtitle: "Home to the 2012 Summer Olympics.",
             .coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)],
            
            [.title: "Oslo",
             .subtitle: "Founded over a thousand years ago.",
             .coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)],
            
            [.title: "Paris",
             .subtitle: "Often called the City of Light.",
             .coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)],
            
            [.title: "Rome",
             .subtitle: "Has a whole country inside it.",
             .coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)],
            
            [.title: "Washington DC",
             .subtitle: "Named after George himself.",
             .coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)]
            
            ])
        
        
        
        return Array.filterNils(array: annotations)
        
    }
    
}


extension MapViewController {
    
    func testWithRandomAnnotations() {
        let randomCoordinates = getRandomCoordinates(quantity: 100)
        let annotations = mapView.getAnnotations(with: randomCoordinates) { coordinate in
            return OTMMapViewAnnotation(with: [.title: "Testing",
                                               .subtitle: "Hey just testing!",
                                               .coordinate : coordinate])
            
        }
        displayAnnotations(annotations)
    }
    
    
    func getRandomCoordinates(quantity: Int) -> [CLLocationCoordinate2D] {
        let Delhi = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
        let London = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        let Oslo = CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)
        let Paris = CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)
        let Rome = CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)
        let WashingtonDC = CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)
        
        let cities = [Delhi, London, Oslo, Paris, Rome, WashingtonDC]
        
        var randomCoordinates = [CLLocationCoordinate2D]()
        for city in cities {
            randomCoordinates.append(contentsOf: mapView.randomLocations(.around(city, within: 500000), quantity: 10))
        }
        
        return randomCoordinates
    }
    
}
