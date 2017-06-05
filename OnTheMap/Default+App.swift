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
        
        enum Address {
            static let Placeholder = "Add Your Location"
            
            enum Label {
                static let Font = UIFont(name: "Helvetica-Light", size: 20)!
                static let NumberOfLines = 0
                static let StressedFont = UIFont(name: "Helvetica", size: 20)!
                static let StressedRange = NSRange(location: 14, length: 8)
                
                enum Text {
                    static let Value = "Where are you\nstudying\ntoday?"
                    static let Color = ArtKit.secondaryColor
                    static let Alignment: NSTextAlignment = .center
                }
            }
        }
        
        
        enum Link {
            static let Placeholder = "Add link to share"
        }
        
        
        enum TextField {
            static let BackgroundColor = ArtKit.shadowOfPrimaryColor
            static let TextColor = ArtKit.secondaryColor
            static let KeyboardAppearance: UIKeyboardAppearance = .dark
            
            enum Placeholder {
                static let TextColor = ArtKit.highlightOfPrimaryColor
                
                enum Shadow {
                    static let Offset = CGSize(width: 0.0, height: 2.0)
                    static let BlurRandius: CGFloat = 4.0
                }
            }
        }
        
        
        enum Button {
            enum Cancel {
                enum Color {
                    static let Normal = ArtKit.shadowOfSecondaryColor
                }
            }
            
            enum Color {
                static let Normal = ArtKit.primaryColor
                static let Highlighted = ArtKit.highlightOfPrimaryColor
            }
        }
        
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
