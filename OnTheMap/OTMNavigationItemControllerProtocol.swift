//
//  OTMNavigationItemControllerProtocol.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 09/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//


protocol OTMNavigationItemControllerProtocol {
    func setupNavigationItem(with controller: inout OTMNavigationItemController?)
    func setupNavigationItem(with controller: inout OTMNavigationItemController?, parent: UIViewController)
}


extension OTMNavigationItemControllerProtocol where Self: UIViewController {
    
    func setupNavigationItem(with controller: inout OTMNavigationItemController?, parent: UIViewController) {
        if controller == nil {
            controller = OTMNavigationItemController(withParent: parent)
        }
    }
    
    func setupNavigationItem(with controller: inout OTMNavigationItemController?) {
        setupNavigationItem(with: &controller, parent: self)
    }
    
    
}
