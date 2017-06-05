//
//  Error_+App.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 30/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension Error_ {
    
    enum App: Error {
        case AddressNotFound
        case BadURL(urlString: String?)
        case NotLoggedIn
        case UserDetailsMissing
        
        var localizedDescription: String {
            var description : String
            switch self {
                
            case .AddressNotFound:
                description = "Couldn't find the address!"
                
            case .BadURL(let urlString):
                description = "Bad url: \(String(describing: urlString))"

            case .UserDetailsMissing:
                description = "Specify all the details before sharing."
                
            case .NotLoggedIn:
                description = "Not logged in."
                
            }
            
            return description
        }
        
    }
    
}


public extension Error {
    
    private var message: String {
        
        let msg: String
        
        if let error = self as? Error_.Udacity {
            msg = error.localizedDescription
            
        } else if let error = self as? Error_.Network.Request {
            msg = error.localizedDescription
            
        } else if let error = self as? Error_.Network.Response {
            msg = error.localizedDescription
            
        } else if let error = self as? Error_.General {
            msg = error.localizedDescription
            
        } else if let error = self as? Error_.App {
            msg = error.localizedDescription
            
        } else if let error = self as? Error_.Google {
            msg = error.localizedDescription
            
        } else if let error = self as? Error_.Facebook {
            msg = error.localizedDescription
            
        } else {
            msg = info()
            
        }
        
        return msg
    }
    
    
    public func alertController(with actions: [UIAlertAction]? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: Default.Alert.Title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertActions = actions ?? [UIAlertAction(title: Default.Alert.Action.Ok.Title,
                                                     style: .default, handler: nil)]
        alertActions.forEach { alertController.addAction($0) }
        return alertController
    }
    
}
