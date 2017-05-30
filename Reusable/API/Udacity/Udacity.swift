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
        var uniqueKey = ""  // Udacity user key or Facebook/Gmail id
        var firstName = ""
        var lastName = ""
        var mapString = ""  // Location name
        var mediaURL: URL? = nil   // URL shared by the Student
        var latitude = 0.0
        var longitude = 0.0
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
//                          MARK: Student Initializers
//******************************************************************************
public extension Udacity.Student {
    
    init(uniqueKey: String, firstName: String, lastName: String) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    init(with dictionary: [String : Any]) {
        
        if let uniqueKey = dictionary[Default.Udacity.ParseAPI.Student.Key.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        }
        
        if let firstName = dictionary[Default.Udacity.ParseAPI.Student.Key.FirstName] as? String {
            self.firstName = firstName
        }
        
        if let lastName = dictionary[Default.Udacity.ParseAPI.Student.Key.LastName] as? String {
            self.lastName = lastName
        }
        
        if let mapString = dictionary[Default.Udacity.ParseAPI.Student.Key.MapString] as? String {
            self.mapString = mapString
        }
        
        if let urlString = dictionary[Default.Udacity.ParseAPI.Student.Key.MediaURL] as? String,
            let mediaURL = URL(string: urlString) {
                self.mediaURL = mediaURL
        }
        
        if let latitude = dictionary[Default.Udacity.ParseAPI.Student.Key.Latitude] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dictionary[Default.Udacity.ParseAPI.Student.Key.Longitude] as? Double {
            self.longitude = longitude
        }
        
    }
    
}


//******************************************************************************
//                          MARK: Header Params
//******************************************************************************
fileprivate extension Udacity {
    
    static func headerParams() -> [String : Any] {
        let headerParams: [String : Any] = [
            Default.Udacity.GeneralAPI.Header.Key.ResponseType : Default.Udacity.GeneralAPI.Header.Value.ResponseType,
            Default.Udacity.GeneralAPI.Header.Key.ContentType : Default.Udacity.GeneralAPI.Header.Value.ContentType
        ]
        return headerParams
    }
    
}


fileprivate extension Udacity.ParseAPI {
    
    static func headerParams() -> [String : Any] {
        let headerParams: [String : Any] = [
            Default.Udacity.ParseAPI.Header.Key.APPId : Default.Udacity.ParseAPI.Header.Value.APPId,
            Default.Udacity.ParseAPI.Header.Key.APIKey : Default.Udacity.ParseAPI.Header.Value.APIKey
        ]
        return headerParams
    }
    
}


//******************************************************************************
//                       MARK: Public Methods (GeneralAPI)
//******************************************************************************
public extension Udacity {
    
    
    public static func login(userName: String,
                             password: String,
                             completion: @escaping (_ success: Bool, _ userKey: String?, _ error: Error?) -> Void) {
        
        let credentials = [
            Default.Udacity.GeneralAPI.Body.Key.Username : userName,
            Default.Udacity.GeneralAPI.Body.Key.Password : password
        ]
        
        // The http body for creating a Udacity login session:
        //
        // {
        //      "udacity" : {
        //          "username" : "shobhit@from101.com"
        //          "password" : "****"
        //      }
        // }
        //
        
        let httpJSONBody: [String : Any] = [
            Default.Udacity.GeneralAPI.Body.Key.Udacity : credentials
        ]
        
        // Get url for GeneralAPI's session method
        if let url = GeneralAPI.url(from: [:], withPathExtension: Default.Udacity.GeneralAPI.Method.Session) {
            
            // Make POST Http request to send the JSON data
            Network.postJSONDict(httpJSONBody,
                                 to: url,
                                 headerParams: headerParams(),
                                 acceptedStatusCodes: Default.Udacity.GeneralAPI.AcceptedStatusCodes,
                                 completion: { (data, error) in
                
                guard let data = data, error == nil else {
                    completion(false, nil, error)
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                    completion(false, nil, Error_.Network.Response.InvalidJSON(url: url, data: data))
                    return
                }
                
                // Parse JSON response: Example of expected JSON response from Udacity:
                // Case 1: Everything goes well.
                // {
                //   "account": {
                //     "registered": true,
                //     "key": "u232507"
                //   },
                //   "session": {
                //     "id": "bbaa33884499003322bbaa33884499003322bbaa338",
                //     "expiration": "2017-07-26T15:56:06.949970Z"
                //   }
                // }
                
                guard let jsonResponse = json as? [String : Any] else {
                    completion(false, nil, Error_.General.DowncastMismatch(for: json, as: [String : Any].self))
                    return
                }
                
                if let account = jsonResponse[Default.Udacity.GeneralAPI.Response.Key.Account] as? [String : Any],
                    let key = account[Default.Udacity.GeneralAPI.Response.Key.UserKey] as? String {
                    completion(true, key, nil)
                    return
                    
                } else if let msg = jsonResponse[Default.Udacity.GeneralAPI.Response.Key.Error] as? String {
                    
                    // Case 2: Some error
                    // {
                    //   "status": 403,
                    //   "error": "Account not found or invalid credentials."
                    // }
                    
                    completion(false, nil, Error_.Udacity.MethodFailed(method: Default.Udacity.GeneralAPI.Method.Session, message: msg))
                    return
                    
                } else {
                    completion(false, nil, Error_.Udacity.MethodFailedWithUnexpectedJSONResponse(forMethod: Default.Udacity.GeneralAPI.Method.Session))
                    return
                }
                
            })
            
        } else {
            completion(false, nil, Error_.Udacity.InvalidURL(sender: GeneralAPI.self))
            return
        }
        
    }
    
    
    public static func logout(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        // Get url for GeneralAPI's session method
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
            
            // Make DELETE Http request
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
        
        // Get url for GeneralAPI's users method
        if let url = GeneralAPI.url(from: [:], withPathExtension: Default.Udacity.GeneralAPI.Method.GetUser) {
            
            // Make GET Http request to get the JSON data
            Network.getJSON(from: url,
                            acceptedStatusCodes: Default.Udacity.GeneralAPI.AcceptedStatusCodes,
                            completion: { (json, error) in
                
                guard let json = json, error == nil else {
                    completion(false, nil, error)
                    return
                }
                
                // Parse JSON response: Example of expected JSON response from Udacity:
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
                    completion(false, nil, Error_.General.DowncastMismatch(for: json, as: [String : Any].self))
                    return
                }
                
                if let user = jsonResponse[Default.Udacity.GeneralAPI.Response.Key.User] as? [String : Any],
                    let firstName = user[Default.Udacity.GeneralAPI.Response.Key.FirstName] as? String,
                    let lastName = user[Default.Udacity.GeneralAPI.Response.Key.LastName] as? String {
                    
                    let student = Student(uniqueKey: studentKey, firstName: firstName, lastName: lastName)
                    completion(true, student, nil)
                    return
                    
                } else if let msg = jsonResponse[Default.Udacity.GeneralAPI.Response.Key.Error] as? String {
                    
                    // Case 2: Some error
                    // {
                    //   "status": 404,
                    //   "error": "Not found: Key('Account', 'u2325078')"
                    // }
                    
                    completion(false, nil, Error_.Udacity.MethodFailed(method: Default.Udacity.GeneralAPI.Method.GetUser, message: msg))
                    return
                    
                } else {
                    completion(false, nil, Error_.Udacity.MethodFailedWithUnexpectedJSONResponse(forMethod: Default.Udacity.GeneralAPI.Method.GetUser))
                    return
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
    
    
    public static func getStudentsLocation(limit: Int = Default.Udacity.ParseAPI.Query.Value.Limit,
                                           skip: Int = Default.Udacity.ParseAPI.Query.Value.Skip,
                                           order: String = Default.Udacity.ParseAPI.Query.Value.Order,
                                           completion: @escaping (_ result: Bool, _ students: [Student]?, _ error: Error?) -> Void) {
        
        let queryParams: [String : Any] = [
            Default.Udacity.ParseAPI.Query.Key.Limit : limit,
            Default.Udacity.ParseAPI.Query.Key.Skip : skip,
            Default.Udacity.ParseAPI.Query.Key.Order : order
        ]
        
        // Get url for ParseAPI's StudentLocation method
        if let url = ParseAPI.url(from: queryParams, withPathExtension: Default.Udacity.ParseAPI.Method.StudentLocation) {
            
            // Make GET Http request to get the JSON data
            Network.getJSON(from: url,
                            headerParams: ParseAPI.headerParams(),
                            acceptedStatusCodes: Default.Udacity.ParseAPI.AcceptedStatusCodes,
                            options: .allowFragments,
                            completion: { (json, error) in
                
                guard let json = json, error == nil else {
                    completion(false, nil, error)
                    return
                }
                
                // Parse JSON response: Example of expected JSON response from Udacity:
                // Case 1: Everything goes well.
                // {
                //   "results": [
                //     ...
                //     {
                //       "objectId": "zausOJdWdd",
                //       "uniqueKey": "10323291078",
                //       "firstName": "Alexander",
                //       "lastName": "Wong",
                //       "mapString": "Houston",
                //       "mediaURL": "Roadtoswe.blogspot.com",
                //       "latitude": 29.7608026,
                //       "longitude": -95.3695062,
                //       "createdAt": "2017-05-27T18:46:54.164Z",
                //       "updatedAt": "2017-05-27T18:46:54.164Z"
                //     }
                //     ...
                //   ]
                // }
                
                guard let jsonResponse = json as? [String : Any] else {
                    completion(false, nil, Error_.General.DowncastMismatch(for: json, as: [String : Any].self))
                    return
                }
                
                guard let results = jsonResponse[Default.Udacity.ParseAPI.Response.Key.Results] as? [[String : Any]] else {
                    completion(false, nil, Error_.General.DowncastMismatch(for: jsonResponse[Default.Udacity.ParseAPI.Response.Key.Results],
                                                                           as: [[String : Any]].self))
                    return
                }
                
                // Construct Student objects from the json data received
                var students = [Student]()
                results.forEach { students.append(Student(with: $0)) }
                
                completion(true, students, nil)
                return
                
            })
            
        } else {
            completion(false, nil, Error_.Udacity.InvalidURL(sender: ParseAPI.self))
            return
        }
        
    }
    
    
    
    public static func postStudentLocation(of student: Student, completion: @escaping (_ result: Bool, _ error: Error?) -> Void) {
        
        // Prepare header parameters
        var header = headerParams()
        header += ParseAPI.headerParams()
        
        // The http body for posting a StudentLocation:
        // {
        //     "uniqueKey" : "u232507",
        //     "firstName" : "Shobhit",
        //     "lastName" : "Gupta",
        //     "mapString" : "Shimla, India",
        //     "mediaURL" : "https://www.from101.com",
        //     "latitude" : 31.1048,
        //     "longitude" : -122.2668
        // }
        
        let httpJSONBody: [String : Any] = [
            Default.Udacity.ParseAPI.Student.Key.UniqueKey : student.uniqueKey,
            Default.Udacity.ParseAPI.Student.Key.FirstName : student.firstName,
            Default.Udacity.ParseAPI.Student.Key.LastName : student.lastName,
            Default.Udacity.ParseAPI.Student.Key.MapString : student.mapString,
            Default.Udacity.ParseAPI.Student.Key.MediaURL : student.mediaURL ?? "",
            Default.Udacity.ParseAPI.Student.Key.Latitude : student.latitude,
            Default.Udacity.ParseAPI.Student.Key.Longitude : student.longitude
        ]
        
        
        // Get url for ParseAPI's StudentLocation method
        if let url = ParseAPI.url(from: [:], withPathExtension: Default.Udacity.ParseAPI.Method.StudentLocation) {
            
            // Make POST Http request to send the JSON data
            Network.postJSONDict(httpJSONBody, to: url, headerParams: header, acceptedStatusCodes: Default.Udacity.ParseAPI.AcceptedStatusCodes, completion: { (data, error) in
                
                guard let data = data, error == nil else {
                    completion(false, error)
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                    completion(false, Error_.Network.Response.InvalidJSON(url: url, data: data))
                    return
                }
                
                // Parse JSON response: Example of expected JSON response from Udacity:
                // Case 1: Everything goes well.
                // {
                //   "objectId": "wkrmfd9VTi",
                //   "createdAt": "2017-05-29T10:39:37.246Z"
                // }
                
                guard let jsonResponse = json as? [String : Any] else {
                    completion(false, Error_.General.DowncastMismatch(for: json, as: [String : Any].self))
                    return
                }
                
                if let _ = jsonResponse[Default.Udacity.ParseAPI.Response.Key.ObjectId] as? String {
                    completion(true, nil)
                    return
                    
                } else if let msg = jsonResponse[Default.Udacity.ParseAPI.Response.Key.Error] as? String {
                    
                    // Case 2: Some error
                    // {"error":"unauthorized"}
                    
                    completion(false, Error_.Udacity.MethodFailed(method: Default.Udacity.ParseAPI.Method.StudentLocation, message: msg))
                    return
                    
                } else {
                    completion(false, Error_.Udacity.MethodFailedWithUnexpectedJSONResponse(forMethod: Default.Udacity.ParseAPI.Method.StudentLocation))
                    return
                    
                }
                
            })
            
        } else {
            completion(false, Error_.Udacity.InvalidURL(sender: ParseAPI.self))
            return
        }
    }
    
}






