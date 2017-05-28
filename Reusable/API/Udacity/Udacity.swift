//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 24/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public struct Udacity {
    
    public struct Student {
        var firstName: String?
        var lastName: String?
        var mapString: String?
        var mediaURL: URL?
        var latitude: String?
        var longitude: String?
    }

    
    fileprivate struct GeneralAPI: SimpleAPI {
        static let scheme = Default.Udacity.GeneralAPI.Scheme
        static let host = Default.Udacity.GeneralAPI.Host
        static let path = Default.Udacity.GeneralAPI.Path
    }
    
    fileprivate struct AuthAPI: SimpleAPI {
        static let scheme = Default.Udacity.AuthAPI.Scheme
        static let host = Default.Udacity.AuthAPI.Host
        static let path = Default.Udacity.AuthAPI.Path
    }
    
    fileprivate struct ParseAPI: SimpleAPI {
        static let scheme = Default.Udacity.ParseAPI.Scheme
        static let host = Default.Udacity.ParseAPI.Host
        static let path = Default.Udacity.ParseAPI.Path
    }
    
}


//******************************************************************************
//                       MARK: Public Methods (GeneralAPI)
//******************************************************************************
public extension Udacity {
    
    public static func login(userName: String,
                             password: String,
                             completion: @escaping (_ success: Bool, _ userKey: String?, _ error: Error?) -> Void) {
        
        let headerParams: [String : Any] = [
            Default.Udacity.GeneralAPI.Header.Key.ResponseType : Default.Udacity.GeneralAPI.Header.Value.ResponseType,
            Default.Udacity.GeneralAPI.Header.Key.ContentType : Default.Udacity.GeneralAPI.Header.Value.ContentType
        ]
        
        let credentials = [
            Default.Udacity.GeneralAPI.Body.Key.Username : userName,
            Default.Udacity.GeneralAPI.Body.Key.Password : password
        ]
        
        // The http body for creating a Udacity login session:
        //
        // {
        //      "udacity" : {
        //          "username" : "abc@xyz.com"
        //          "password" : "****"
        //      }
        // }
        //
        
        let httpJSONBody: [String : Any] = [
            Default.Udacity.GeneralAPI.Body.Key.Udacity : credentials
        ]
        
        if let url = GeneralAPI.url(from: [:], withPathExtension: Default.Udacity.GeneralAPI.Method.Session) {
            
            Network.postJSONDict(httpJSONBody,
                                 to: url, headerParams: headerParams,
                                 acceptedStatusCodes: Default.Udacity.GeneralAPI.AcceptedStatusCodes,
                                 completion: { (data, error) in
                
                guard let data = data, error == nil else {
                    completion(false, nil, error)
                    return
                }
                
                guard let jsonResponse = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else {
                    completion(false, nil, Error_.Network.Response.InvalidJSON(url: url, data: data))
                    return
                }
                
                // Example of expected JSON response from Udacity:
                // Case 1: Everything goes well.
                // {
                //   "account": {
                //     "registered": true,
                //     "key": "u232507"
                //   },
                //   "session": {
                //     "id": "1527436566S8979bf225f78f9b956a4ad9b163797f1",
                //     "expiration": "2017-07-26T15:56:06.949970Z"
                //   }
                // }
                
                if let account = jsonResponse[Default.Udacity.GeneralAPI.Response.Key.Account] as? [String : Any],
                    let key = account[Default.Udacity.GeneralAPI.Response.Key.UserKey] as? String {
                    completion(true, key, nil)
                    return
                    
                } else {
                    
                    // Case 2: Some error
                    // {
                    //   "status": 403,
                    //   "error": "Account not found or invalid credentials."
                    // }
                    
                    if let msg = jsonResponse[Default.Udacity.GeneralAPI.Response.Key.Error] as? String {
                        completion(false, nil, Error_.Udacity.LoginFailed(message: msg))
                        return
                    }
                    
                }
                
            })
            
        } else {
            completion(false, nil, Error_.Udacity.InvalidURL(sender: GeneralAPI.self))
            return
        }
        
    }
    
    
    public static func logout(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        if let url = GeneralAPI.url(from: [:], withPathExtension: Default.Udacity.GeneralAPI.Method.Session) {
            
            var headerParams: [String : Any] = [:]
            
            // Handle Cookies
            if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                var xsrfCookie: HTTPCookie? = nil
                for cookie in cookies {
                    if cookie.name == "XSRF-TOKEN" {
                        xsrfCookie = cookie
                    }
                }
                if let cookieValue = xsrfCookie?.value {
                    headerParams = [
                        "X-XSRF-Token" : cookieValue
                    ]
                }
            }
            
            Network.deleteRequest(to: url, headerParams: headerParams, completion: { (data, error) in
                guard let _ = data, error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
                return
                
            })
            
        } else {
            completion(false, Error_.Udacity.InvalidURL(sender: GeneralAPI.self))
            return
        }
        
    }
    
    
    public static func studentInfo(for studentKey: String, completion: @escaping (_ success: Bool, _ student: Student?, _ error: Error?) -> Void) {
        
        if let url = GeneralAPI.url(from: [:], withPathExtension: Default.Udacity.GeneralAPI.Method.GetUser) {
            
            Network.getJSON(from: url,
                            acceptedStatusCodes: Default.Udacity.GeneralAPI.AcceptedStatusCodes,
                            completion: { (json, error) in
                
                guard let json = json, error == nil else {
                    completion(false, nil, error)
                    return
                }
                
                // Example of expected JSON response from Udacity:
                // Case 1: Everything goes well.
                // {
                //   "user": {
                //     ...
                //     "last_name": "Gupta",
                //     "first_name": "Shobhit",
                //     ...
                //   }
                // }
                
                guard let jsonResponse = json as? [String : Any] else {
                    completion(false, nil, Error_.Udacity.UnexpectedJSON(expected: [String : Any].self, received: type(of: json)))
                    return
                }
                
                if let user = jsonResponse[Default.Udacity.GeneralAPI.Response.Key.User] as? [String : Any],
                    let firstName = user[Default.Udacity.GeneralAPI.Response.Key.FirstName] as? String,
                    let lastName = user[Default.Udacity.GeneralAPI.Response.Key.LastName] as? String {
                    
                    let student = Student(firstName: firstName,
                                          lastName: lastName,
                                          mapString: nil,
                                          mediaURL: nil,
                                          latitude: nil, longitude: nil)
                    
                    completion(true, student, nil)
                    
                } else {
                    
                    // Case 2: Some error
                    // {
                    //   "status": 404,
                    //   "error": "Not found: Key('Account', 'u2325078')"
                    // }
                    
                    if let msg = jsonResponse[Default.Udacity.GeneralAPI.Response.Key.Error] as? String {
                        completion(false, nil, Error_.Udacity.UserInfoFetchingFailed(message: msg))
                        return
                    }
                }
                
            })
            
        } else {
            completion(false, nil, Error_.Udacity.InvalidURL(sender: GeneralAPI.self))
            return
        }
    }
    
}


//******************************************************************************
//                       MARK: Public Methods (ParseAPI)
//******************************************************************************
public extension Udacity {
    
    public static func getStudentsLocation(completion: (_ result: Bool, _ students: [Student]?, _ error: Error?) -> Void) {
        
    }
    
    
    public static func postStudentLocation(of student: Student, completion: (_ result: Bool, _ error: Error?) -> Void) {
        
    }
    
}




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


public extension Error_ {
    enum Udacity: Error {
        case LoginFailed(message: String)
        case InvalidURL(sender: Any.Type)
        case UnexpectedJSON(expected: Any.Type, received: Any.Type)
        case UserInfoFetchingFailed(message: String)
        
        var localizedDescription: String {
            var description = String(describing: self)
            switch self {
            
            case .LoginFailed(let message):
                description += message
                
            case .InvalidURL(let sender):
                description += "Couldn't construct url for Udacity API: \(sender)"
             
            case let .UnexpectedJSON(expected, received):
                description += "Received JSON of type: \(received) while expecting: \(expected)"
                
            case .UserInfoFetchingFailed(let message):
                description += message
                
            }
            
            return description
        }
        
    }
}
