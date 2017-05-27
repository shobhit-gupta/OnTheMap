//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 24/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


struct Udacity {
    
    struct GeneralAPI: SimpleAPI {
        static let scheme = Default.Udacity.GeneralAPI.Scheme
        static let host = Default.Udacity.GeneralAPI.Host
        static let path = Default.Udacity.GeneralAPI.Path
    }
    
    struct AuthAPI: SimpleAPI {
        static let scheme = Default.Udacity.AuthAPI.Scheme
        static let host = Default.Udacity.AuthAPI.Host
        static let path = Default.Udacity.AuthAPI.Path
    }
    
    struct ParseAPI: SimpleAPI {
        static let scheme = Default.Udacity.ParseAPI.Scheme
        static let host = Default.Udacity.ParseAPI.Host
        static let path = Default.Udacity.ParseAPI.Path
    }
    
}




public extension Default {
    
    enum Udacity {
        
        enum GeneralAPI {
            static let Scheme = "https"
            static let Host = "www.udacity.com"
            static let Path = "/api"
            
            enum Method {
                static let Session = "session"
                static let GetUser = "users"
            }

            
            enum Header {
                enum Key {
                    static let ResponseType = "Accept"
                    static let ContentType = "Content-Type"
                }
                
                enum Value {
                    static let ResponseType = "application/json"
                    static let ContentType = "application/json"
                }
            }

            
            enum Body {
                enum Key {
                    static let Udacity = "udacity"
                    static let Username = "username"
                    static let Password = "password"
                }
                
                enum Value {}
            }
            
            
            enum Response {
                enum Key {
                    static let Account = "account"
                    static let UserKey = "key"
                    static let User = "user"
                    static let FirstName = "first_name"
                    static let LastName = "last_name"
                }
                
                enum Value {}
            }
            
        }
        
        
        enum AuthAPI {
            static let Scheme = "https"
            static let Host = "auth.udacity.com"
            static let Path = ""
            
            enum Method {
                static let SignUp = "sign-up"
            }

            enum Query {
                enum Key {
                    static let NextPage = "next"
                }
                
                enum Value {
                    static let NextPage = "https://classroom.udacity.com/authenticated"
                }
            }
            
        }
        
        
        enum ParseAPI {
            static let Scheme = "https"
            static let Host = "parse.udacity.com"
            static let Path = "/parse/classes"
            
            enum Method {
                static let StudentLocation = "StudentLocation"
            }
            
            
            enum Header {
                enum Key {
                    static let APPId = "X-Parse-Application-Id"
                    static let APIKey = "X-Parse-REST-API-Key"
                }
                
                enum Value {
                    static let APPId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
                    static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
                }
            }

            
            enum Query {
                enum Key {
                    static let Limit = "limit"
                    static let Skip = "skip"
                    static let Order = "order"
                }
                
                enum Value {
                    static let Limit = 100
                    static let Skip = 0
                    static let Order = "-updatedAt"
                }
            }
            
            
            enum Student {
                enum Key {
                    static let UniqueKey = "uniqueKey"
                    static let FirstName = "firstName"
                    static let LastName = "lastName"
                    static let MapString = "mapString"
                    static let MediaURL = "mediaURL"
                    static let Latitude = "latitude"
                    static let Longitude = "longitude"
                }
                
                enum Value {}
            }
            
        }
        
        
    }
    
    
}
