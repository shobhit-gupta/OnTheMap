//
//  OTMNavigationItem.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 07/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

class OTMNavigationItem: UINavigationItem {
    
    weak var delegate: OTMNavigationItemDelegate? {
        didSet {
            setup()
        }
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setup() {
        
        if let delegate = delegate {
            
            if delegate.shouldDisplayLogoutButton() {
                leftBarButtonItem = UIBarButtonItem(barButtonItemData:
                    BarButtonItemData(with: [.title : "Logout", .target : delegate, .action : #selector(delegate.logoutButtonPressed)]))
                
            }
            
            rightBarButtonItems = UIBarButtonItem.getBarButtonItems(withDictionaries: [
                [.image : #imageLiteral(resourceName: "RefreshIcon"), .target : delegate, .action : #selector(delegate.refreshButtonPressed)],
                [.image : #imageLiteral(resourceName: "PinIcon"), .target : delegate, .action : #selector(delegate.pinButtonPressed)]
            ])
            
        }
        
        title = "On The Map"
        
    }
    
    
    
}
