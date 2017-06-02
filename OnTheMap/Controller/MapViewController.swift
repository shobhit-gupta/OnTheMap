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
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: Private variables and types
    fileprivate var annotations: [MKAnnotation] {
        var otmMapViewAnnotationsDict = [[OTMMapViewAnnotationKeys : Any]]()
        
        OTMModel.shared.students.forEach {
            
            let otmMapViewAnnotationDict: [OTMMapViewAnnotationKeys : Any] = [
                .title: "\($0.firstName) \($0.lastName)",
                .subtitle: $0.mediaURL?.absoluteString ?? Default.Message.NoLinkShared,
                .coordinate: CLLocationCoordinate2D(latitude: $0.latitude as CLLocationDegrees,
                                                    longitude: $0.longitude as CLLocationDegrees)]
            
            otmMapViewAnnotationsDict.append(otmMapViewAnnotationDict)
        }
        
        
        return Array.filterNils(array: OTMMapViewAnnotation.getOTMMapViewAnnotations(with: otmMapViewAnnotationsDict))
    }

    internal var otmNavigationItemController: OTMNavigationItemController?
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupOTMAnnotations()
        subscribeToNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromNotification()
    }
    
}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension MapViewController {
    
    fileprivate func setupUI() {
        setupMapView()
        setupNavigationItem()
        //setupOTMAnnotations()
    }
    
    
    private func setupMapView() {
        mapView.delegate = self
    }
    
    
    private func setupNavigationItem() {
        createOTMNavigationItemController(&otmNavigationItemController)
        otmNavigationItemController?.otmNavigationItem?.title = Default.MapView.Title
    }

    
    fileprivate func setupOTMAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    
}


//******************************************************************************
//                   MARK: OTMNavigationItemControllerProtocol
//******************************************************************************
extension MapViewController: OTMNavigationItemControllerProtocol {}


//******************************************************************************
//                              MARK: Notifications
//******************************************************************************
extension MapViewController {
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(studentsLocationModified(_:)),
                                               name: Notification.Name(rawValue: Default.Notification_.StudentsLocationModified.rawValue),
                                               object: nil)
    }
    
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func studentsLocationModified(_ notification: Notification) {
        DispatchQueue.main.async {
            self.setupOTMAnnotations()
        }
    }
    
    
}


//******************************************************************************
//                              MARK: MKMapViewDelegate
//******************************************************************************
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = Default.MapView.Annotation.ReusableCellId
        
        if annotation is OTMMapViewAnnotation {
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: Default.MapView.Annotation.CallOutButtonType)
                
            } else {
                annotationView?.annotation = annotation
            }
        
            return annotationView
        }
        
        return nil
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation,
            let subtitle = annotation.subtitle,
            let urlString = subtitle,
            let url = URL(string: urlString) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}



//******************************************************************************
//                              MARK: Testing
//******************************************************************************
//extension MapViewController {
//    
//    func createOTMAnnotations() -> [OTMMapViewAnnotation] {
//        let annotations = OTMMapViewAnnotation.getOTMMapViewAnnotations(with: [
//            [.title: "Delhi",
//             .subtitle: "Asia’s Largest Wholesale Spice Market",
//             .coordinate: CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)],
//            
//            [.title: "London",
//             .subtitle: "Home to the 2012 Summer Olympics.",
//             .coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)],
//            
//            [.title: "Oslo",
//             .subtitle: "Founded over a thousand years ago.",
//             .coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)],
//            
//            [.title: "Paris",
//             .subtitle: "Often called the City of Light.",
//             .coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)],
//            
//            [.title: "Rome",
//             .subtitle: "Has a whole country inside it.",
//             .coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)],
//            
//            [.title: "Washington DC",
//             .subtitle: "Named after George himself.",
//             .coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)]
//            
//            ])
//        
//        return Array.filterNils(array: annotations)
//        
//    }
//    
//}
//
//
//extension MapViewController {
//    
//    func testWithRandomAnnotations() {
//        let randomCoordinates = getRandomCoordinates(quantity: 100)
//        let annotations = mapView.getAnnotations(with: randomCoordinates) { coordinate in
//            return OTMMapViewAnnotation(with: [.title: "Testing",
//                                               .subtitle: "Hey just testing!",
//                                               .coordinate : coordinate])
//            
//        }
//        displayAnnotations(annotations)
//    }
//    
//    
//    func getRandomCoordinates(quantity: Int) -> [CLLocationCoordinate2D] {
//        let Delhi = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
//        let London = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
//        let Oslo = CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)
//        let Paris = CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)
//        let Rome = CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)
//        let WashingtonDC = CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)
//        
//        let cities = [Delhi, London, Oslo, Paris, Rome, WashingtonDC]
//        
//        var randomCoordinates = [CLLocationCoordinate2D]()
//        for city in cities {
//            randomCoordinates.append(contentsOf: mapView.randomLocations(.around(city, within: 500000), quantity: 10))
//        }
//        
//        return randomCoordinates
//    }
//    
//}
