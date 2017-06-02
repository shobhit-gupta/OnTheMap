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
    
    
    enum Message {
        static let NoLinkShared = "Hasn't shared any link"
    }
    
    
    enum MapView {
        static let Title = "Students On the Map"
        
        enum Annotation {
            static let ReusableCellId = "StudentLocationAnnotation"
            static let CallOutButtonType = UIButtonType.detailDisclosure
        }
    }
    
    
    enum ListView {
        static let Title = "Students List"
    }
    
    
    enum ListViewCell {
        static let ReusableCellId = "ListViewCell"
    }
    
    
    enum InfoPostingView {
        static let Id = "InformationPostingView"
    }
    
    
    enum Alert {
        static let Title = "Error"
        enum Action {
            enum Ok {
                static let Title = "Ok"
            }
        }
    }
    
    
    enum BarButtonItemLabel {
        static let Logout = "Logout"
    }
    
    
    enum Segues {
    
        enum FromLogin: String {
            case ToTabbedView = "fromLoginToTabbedView"
        }
        
    }
    
    
    enum Notification_: String {
        case StudentsLocationModified = "StudentsLocationModified"
        case StudentsLocationRefreshRequested = "StudentsLocationRefreshRequested"
        
        func post(to notificationCenter: NotificationCenter = NotificationCenter.default) {
            let notification = Notification(name: Notification.Name(rawValue: self.rawValue))
            notificationCenter.post(notification)
        }
    }
    
}


public extension Default.BusyView {
    
    static let OuterIndicatorImage = #imageLiteral(resourceName: "LoadingIcon")
    static let InnerIndicatorImage = #imageLiteral(resourceName: "PinIcon")
    
    enum LoggingIn {
        static let Title = "Please Wait"
        static let Subtitle = "Logging in..."
    }
    
    enum LoggingOut {
        static let Title = "Please Wait"
        static let Subtitle = "Logging out..."
    }
    
    enum LookingUpAddress {
        static let Title = "Please Wait"
        static let Subtitle = "Looking up on map..."
    }
    
    enum PostStudentLocation {
        static let Title = "Please Wait"
        static let Subtitle = "Sending your greetings to other Udacians!"
    }
    
    
}
