//
//  OTMNavigationItemControllerProtocol.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 09/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//


protocol OTMNavigationItemControllerProtocol {
    var otmNavigationItemController: OTMNavigationItemController? { get }
    func createOTMNavigationItemController(_ controller: inout OTMNavigationItemController?)
}


extension OTMNavigationItemControllerProtocol where Self: UIViewController {
    
    func createOTMNavigationItemController(_ controller: inout OTMNavigationItemController?) {
        if controller == nil {
            controller = OTMNavigationItemController(withParent: self)
        }
    }
    
    
}
