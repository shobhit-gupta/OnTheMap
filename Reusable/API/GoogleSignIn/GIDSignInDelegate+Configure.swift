//
//  GIDSignInDelegate+Configure.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 03/06/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension GIDSignInDelegate {

    func configureGGLContext() -> Bool {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        guard configureError == nil else {
            print(Error_.Google.ConfigurationFailed(error: configureError).localizedDescription)
            return false
        }
        
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    

}


public extension Error_ {
    
    enum Google: Error {
        case ConfigurationFailed(error: Error?)
        
        var localizedDescription: String {
            let description : String
            switch self {
                
            case .ConfigurationFailed(let error):
                description = "Error configuring Google services: \(String(describing: error))"
                
            }
            
            return description
        }
    }
    
}
