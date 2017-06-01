//
//  Default+App.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 19/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension Default {
    
    enum StackView {
        enum Separator {
            static let Thickness: CGFloat = 1.0
            static let Color = UIColor.init(netHex: 0xDBE2E8)!
            static let Padding: CGFloat = 20.0
        }
    }
    
    
    enum MapView {
        static let Title = "Students On the Map"
        
        enum Annotation {
            static let ReusableCellId = "StudentLocationAnnotation"
        }
    }
    
    
    enum ListView {
        static let Title = "Students List"
    }
    
    
    enum ListViewCell {
        static let ReusableCellId = "ListViewCell"
    }
    
    
    enum Segues {
    
        enum FromLogin: String {
            case ToTabbedView = "fromLoginToTabbedView"
        }
        
    }
    
    
    enum Notification: String {
        case StudentsLocationModified = "StudentsLocationModified"
        case StudentsLocationRefreshRequested = "StudentsLocationRefreshRequested"
    }
    
}
