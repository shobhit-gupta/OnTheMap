//
//  OTMMapViewAnnotation.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 09/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit
import MapKit


enum OTMMapViewAnnotationKeys {
    case title
    case subtitle
    case coordinate
}


class OTMMapViewAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    
    init?(with dictionary: [OTMMapViewAnnotationKeys : Any]) {
        
        guard let coordinate = dictionary[.coordinate] as? CLLocationCoordinate2D else {
            return nil
        }
        
        title = dictionary[.title] as? String
        subtitle = dictionary[.subtitle] as? String
        self.coordinate = coordinate
        super.init()
    }
    
}


extension OTMMapViewAnnotation {
    
    class func getOTMMapViewAnnotations(with dictionaries: [[OTMMapViewAnnotationKeys : Any]]) -> [OTMMapViewAnnotation?] {
        return dictionaries.map {
            OTMMapViewAnnotation(with: $0)
        }
    }
    
}
