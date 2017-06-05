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
        self.parent = parent
        if let otmNavigationItem = otmNavigationItem {
            otmNavigationItem.delegate = self
        }
    }
    
    
    func refreshButtonPressed() {
        Default.Notification_.StudentsLocationRefreshRequested.post()
    }
    
    
    func pinButtonPressed() {
        if let controller = parent.storyboard?.instantiateViewController(withIdentifier: Default.InfoPostingView.Id) {
            parent.present(controller, animated: true, completion: nil)
        }
    }
    
    
    func shouldDisplayLogoutButton() -> Bool {
        //return OTMModel.shared.loginMethod == .udacity || OTMModel.shared.loginMethod == .google
        return true
    }
    
    
    func logoutButtonPressed() {
        
        let view: UIView = UIApplication.shared.keyWindow ?? parent.view

        let busyView = BusyView.overlay(on: view, withTitle: Default.BusyView.LoggingOut.Title,
                                        subtitle: Default.BusyView.LoggingOut.Subtitle,
                                        outerIndicatorImage: Default.BusyView.OuterIndicatorImage,
                                        innerIndicatorImage: Default.BusyView.InnerIndicatorImage)
        busyView.present()
        
        OTMModel.shared.logout { (success, error) in
            busyView.dismiss()
            busyView.removeFromSuperview()
            
            guard success else {
                if let error = error {
                    self.parent.present(error.alertController(), animated: true, completion: nil)
                }
                return
            }
            
            self.parent.dismiss(animated: false, completion: nil)
            
        }
        
    }
    
    
}
