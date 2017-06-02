//
//  Error_+Udacity.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 30/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension Error_ {
    
    enum Udacity: Error {
        case InvalidURL(sender: Any.Type)
        case MethodFailed(method: String, message: String)
        case MethodFailedWithUnexpectedJSONResponse(forMethod: String)
        
        var localizedDescription: String {
            let description = String(describing: self) + " " + userDescription
            return description
        }
        
        var userDescription: String {
            let description : String
            switch self {
                
            case .InvalidURL(let sender):
                description = "Couldn't construct url for Udacity API: \(sender)"
                
            case let .MethodFailed(method, message):
                description = "\(method) method failed: \(message)"
                
            case .MethodFailedWithUnexpectedJSONResponse(let method):
                description = "\(method) method failed: Unexpected JSON Response"
                
            }
            
            return description
        }
        
    }
    
}
