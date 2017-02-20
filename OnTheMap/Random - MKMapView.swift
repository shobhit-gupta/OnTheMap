//
//  Random - MKMapView.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 10/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation
import MapKit


extension MKMapView {
    
    enum RandomLocationType {
        case acrossWorld
        case acrossView
        case around(CLLocationCoordinate2D, within: CLLocationDistance)
    }
    
    
    func randomLocation(_ randomLocationType: RandomLocationType) -> CLLocationCoordinate2D {
        
        let randomPoint: CGPoint
        let locationForRandomPoint: CLLocationCoordinate2D
        
        switch randomLocationType {
            
        case .acrossWorld:
            randomPoint = CGPoint(x: CGFloat.random(lower: -90, upper: 90), y: CGFloat.random(lower: -180, upper: 180))
            locationForRandomPoint = CLLocationCoordinate2D(latitude: CLLocationDegrees(randomPoint.x), longitude: CLLocationDegrees(randomPoint.y))
            
        case .acrossView:
            randomPoint = CGPoint.randomWithinCGRect(rectangle: self.bounds)
            locationForRandomPoint = convert(randomPoint, toCoordinateFrom: self)
            
        case .around(let location, let distance):
            let validRegion = MKCoordinateRegionMakeWithDistance(location, distance, distance)
            let validRect = convertRegion(validRegion, toRectTo: self)
            randomPoint = CGPoint.randomWithinCGRect(rectangle: validRect)
            locationForRandomPoint = convert(randomPoint, toCoordinateFrom: self)
        
        }
        
        return locationForRandomPoint
        
    }
    
    
    func randomLocations(_ randomLocationType: RandomLocationType, quantity: Int) -> [CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D]()
        for _ in 1...quantity {
            coordinates.append(randomLocation(randomLocationType))
        }
        return coordinates
    }
    
    
    func getAnnotations(with coordinates: [CLLocationCoordinate2D], optionalAnnotationBuilder: (CLLocationCoordinate2D) -> MKAnnotation?) -> [MKAnnotation] {
        return Array.filterNils(array: coordinates.map {
            optionalAnnotationBuilder($0)
        })
    }
    
    
    func getAnnotations(with coordinates: [CLLocationCoordinate2D], annotationBuilder: (CLLocationCoordinate2D) -> MKAnnotation) -> [MKAnnotation] {
        return coordinates.map {
            annotationBuilder($0)
        }
    }
    
    
}
