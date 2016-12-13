//
//  OTMNavigationItemController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 08/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation

class OTMNavigationItemController: OTMNavigationItemDelegate {
    
    let parent: UIViewController!
    
    var otmNavigationItem: OTMNavigationItem? {
        return parent.navigationItem as? OTMNavigationItem
    }
    
    
    init(withParent parent: UIViewController) {
        print("OTMNavigationItemController initialised")
        self.parent = parent
        if let otmNavigationItem = otmNavigationItem {
            otmNavigationItem.delegate = self
        }
    }
    
    
    func refreshButtonPressed() {
        // TODO: Update models
    }
    
    
    func pinButtonPressed() {
        // TODO: Modally present Information Posting View
        print("pinButtonPressed")
        if let controller = parent.storyboard?.instantiateViewController(withIdentifier: "InformationPostingView") {
            parent.present(controller, animated: true, completion: nil)
        }
    }
    
    
    func shouldDisplayLogoutButton() -> Bool {
        // TODO: Depending upon the login mechanism return an appropriate value
        return true
    }
    
    
    func logoutButtonPressed() {
        // TODO: Logout
    }
    
    
}
