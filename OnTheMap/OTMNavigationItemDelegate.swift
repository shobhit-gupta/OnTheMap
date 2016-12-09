//
//  OTMNavigationItemDelegate.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 08/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation

@objc
protocol OTMNavigationItemDelegate: class {
    func refreshButtonPressed()
    func pinButtonPressed()
    func shouldDisplayLogoutButton() -> Bool
    func logoutButtonPressed()
}
