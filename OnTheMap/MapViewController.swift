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
    
    var otmNavigationItemController: OTMNavigationItemController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createOTMNavigationItemController(&otmNavigationItemController)
    }
    
}


extension MapViewController: OTMNavigationItemControllerProtocol {}
