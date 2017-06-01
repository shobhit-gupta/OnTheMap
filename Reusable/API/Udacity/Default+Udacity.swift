//
//  Default+Udacity.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 30/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension Default {
    
    enum Udacity {
        
        enum GeneralAPI {
            static let Scheme = "https"
            static let Host = "www.udacity.com"
            static let Path = "/api"
            static let AcceptedStatusCodes = [200...299, 400...499]
            
            enum Method {
                static let Session = "session"
                static let GetUser = "users"
                
                static func GetUser(withExtension: String) -> String {
                    return GetUser + "/" + withExtension
                }
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
                    static let Error = "error"
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
            static let AcceptedStatusCodes = [200...299, 400...499]
            
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
            
            
            enum Response {
                enum Key {
                    static let Results = "results"
                    static let ObjectId = "objectId"
                    static let Error = "error"
                }
                
                enum Value {}
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
