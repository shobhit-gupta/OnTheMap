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
        case UserDetailsMissing
        case AddressNotFound
        
        var localizedDescriptionVerbose: String {
            let description = String(describing: self) + " " + localizedDescription
            return description
        }
        
        var localizedDescription: String {
            var description : String
            switch self {
                
            case .UserDetailsMissing:
                description = "Specify all the details before sharing."
                
            case .AddressNotFound:
                description = "Couldn't find the address!"
                
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
            
        } else {
            msg = info()
            
        }
        
        return msg
    }
    
    
    public func alertController(with actions: [UIAlertAction]? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        let alertActions = actions ?? [UIAlertAction(title: "Ok", style: .default, handler: nil)]
        alertActions.forEach { alertController.addAction($0) }
        return alertController
    }
    
}
