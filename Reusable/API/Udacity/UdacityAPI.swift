//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 24/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


struct UdacityAPI: SimpleAPI {
    static let scheme = Default.UdacityAPI.Scheme
    static let host = Default.UdacityAPI.Host
    static let path = Default.UdacityAPI.Path
    
}


public extension Default {
    enum UdacityAPI {
        static let Scheme = "https"
        static let Host = "udacity.com"
        static let Path = "/"
        
        enum Param {
            
            enum Key {
                
            }
            
            enum Value {
                
            }
            
        }
        
        
        enum Response {
            
            enum Key {
                
            }
            
            enum Value {
                
            }
            
        }
        
    }
    
}
