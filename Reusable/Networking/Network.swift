//
//  Network.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 25/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public class Network: NSObject {
    
    public class func dataTask(with urlRequest: URLRequest,
                               acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                               completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = urlRequest.url else {
            completion(nil, Error_.Network.Request.NoURLFound(in: urlRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            // Was there an error?
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            // Did we get an acceptable response?
            let statusCodeOptional = (response as? HTTPURLResponse)?.statusCode
            guard let statusCode = statusCodeOptional,
                acceptedStatusCodes.contains(where: { $0.overlaps(statusCode...statusCode) }) else {
                    completion(nil, Error_.Network.Response.UnacceptableStatusCode(statusCodeOptional, acceptedStatusCodes: acceptedStatusCodes, url: url))
                    return
            }
            
            // Was there any data returned?
            guard let data = data else {
                completion(nil, Error_.Network.Response.NoData(url: url))
                return
            }
            
            completion(data, nil)
            
            }.resume()
        
    }
    
}


//******************************************************************************
//                              MARK: Get
//******************************************************************************
public extension Network {
    
    
    public class func getData(from url: URL,
                              headerParams: [String : Any] = Default.URL_.HeaderParams,
                              acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                              completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        return dataTask(with: URLRequest(url: url, headerParams: headerParams),
                        acceptedStatusCodes: acceptedStatusCodes,
                        completion: completion)
    }
    
    
    
    public class func getImage(from url: URL,
                               headerParams: [String : Any] = [:],
                               acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                               completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        getData(from: url,
                headerParams: headerParams,
                acceptedStatusCodes: acceptedStatusCodes) { (data, error) in
            
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, Error_.Network.Response.NotAnImage(url: url))
            }
        }
    }
    
    
    
    public class func getJSON(from url: URL,
                              headerParams: [String : Any] = Default.URL_.HeaderParams,
                              acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                              options opt: JSONSerialization.ReadingOptions = [],
                              ignorePrefix prefix: Int = 0,
                              ignorePostfix postfix: Int = 0,
                              completion: @escaping (_ json: Any?, _ error: Error?) -> Void) {
        var headerParams = headerParams
        headerParams[Default.URL_.Header.Key.ResponseType] = Default.URL_.Header.Value.ResponseType.JSON
        
        getData(from: url,
                headerParams: headerParams,
                acceptedStatusCodes: acceptedStatusCodes) { (data, error) in
            
            guard var data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            data = data.subdata(in: Range(prefix..<data.count - postfix))
                    
            if let parsedResult = try? JSONSerialization.jsonObject(with: data, options: opt),
                parsedResult is [String : Any] || parsedResult is [Any] {
                completion(parsedResult, nil)
            } else {
                completion(nil, Error_.Network.Response.InvalidJSON(url: url, data: data))
                return
            }
            
        }
    }
    
    
}


//******************************************************************************
//                              MARK: Post
//******************************************************************************
public extension Network {
    
    
    private class func postJSON(_ json: Data,
                                to url: URL,
                                headerParams: [String : Any] = Default.URL_.HeaderParams,
                                acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                                completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        var urlRequest = URLRequest(url: url, headerParams: headerParams)
        
        // Configure header
        urlRequest.httpMethod = Default.URL_.HTTPMethod.Post
        if urlRequest.value(forHTTPHeaderField: Default.URL_.Header.Key.ContentType) == nil {
            urlRequest.addValue(Default.URL_.Header.Value.ContentType.JSON, forHTTPHeaderField: Default.URL_.Header.Key.ContentType)
        }
        
        // Body
        urlRequest.httpBody = json
        
        // Perform POST
        dataTask(with: urlRequest,
                 acceptedStatusCodes: acceptedStatusCodes,
                 completion: completion)
        
    }
    
    
    
    public class func postJSONString(_ json: String,
                                     to url: URL,
                                     headerParams: [String : Any] = Default.URL_.HeaderParams,
                                     acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                                     completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        guard let postData = json.data(using: .utf8) else {
            completion(nil, Error_.Network.Request.ToJSONConversionFailed(from: json))
            return
        }
        
        return postJSON(postData,
                        to: url,
                        headerParams: headerParams,
                        acceptedStatusCodes: acceptedStatusCodes,
                        completion: completion)
    }
    
    
    
    public class func postJSONArray(_ json: [Any],
                                    to url: URL,
                                    headerParams: [String : Any] = Default.URL_.HeaderParams,
                                    acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                                    completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        guard let postData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            completion(nil, Error_.Network.Request.ToJSONConversionFailed(from: json))
            return
        }
        
        return postJSON(postData,
                        to: url,
                        headerParams: headerParams,
                        acceptedStatusCodes: acceptedStatusCodes,
                        completion: completion)
    }
    
    
    
    public class func postJSONDict(_ json: [String : Any],
                                   to url: URL,
                                   headerParams: [String : Any] = Default.URL_.HeaderParams,
                                   acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                                   completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        guard let postData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            completion(nil, Error_.Network.Request.ToJSONConversionFailed(from: json))
            return
        }
        
        return postJSON(postData,
                        to: url,
                        headerParams: headerParams,
                        acceptedStatusCodes: acceptedStatusCodes,
                        completion: completion)
    }
    
    
}


//******************************************************************************
//                              MARK: Delete
//******************************************************************************
public extension Network {
    
    public class func deleteRequest(to url: URL,
                              headerParams: [String : Any] = Default.URL_.HeaderParams,
                              acceptedStatusCodes: [CountableClosedRange<Int>] = Default.URL_.AcceptedStatusCodes,
                              completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        var urlRequest = URLRequest(url: url, headerParams: headerParams)
        urlRequest.httpMethod = Default.URL_.HTTPMethod.Delete
        
        return dataTask(with: urlRequest,
                        acceptedStatusCodes: acceptedStatusCodes,
                        completion: completion)
    }
    
    
}


public extension Default.URL_ {
    
    static let HeaderParams: [String : Any] = [:]
    static let AcceptedStatusCodes = [200...299]
    
    enum HTTPMethod {
        static let Delete = "Delete"
        static let Get = "GET"
        static let Post = "POST"
    }
    
    
    enum Header {
        enum Key {
            static let ResponseType = "Accept"
            static let ContentType = "Content-Type"
        }
        
        enum Value {
            
            enum ResponseType {
                static let JSON = "application/json"
            }
            
            enum ContentType {
                static let JSON = "application/json"
            }
        }
    }
    
}




public extension Error_.Network {
    
    enum Response: Error {
        case InvalidJSON(url: URL, data: Data?)
        case NoData(url: URL)
        case NotAnImage(url: URL)
        case UnacceptableStatusCode(Int?, acceptedStatusCodes: [CountableClosedRange<Int>], url: URL)
        
        
        var localizedDescriptionVerbose: String {
            let description = String(describing: self) + " " + localizedDescription
            return description
        }
        
        var localizedDescription: String {
            var description : String
            switch self {
                
            case let .InvalidJSON(url, data):
                description = "Can't construct JSON from the data returned by: \(url)"
                if let data = data {
                    description += "\nData Returned: \(data)"
                }

            case .NoData(let url):
                description = "No data was returned by: \(url)"
                
            case .NotAnImage(let url):
                description = "Can't construct an image from the data returned by: \(url)"
                
            case let .UnacceptableStatusCode(statusCode, acceptedStatusCodes, url):
                description = "StatusCode \(String(describing: statusCode)) other than the accepted status codes: \(acceptedStatusCodes) returned by: \(url)"
                
            }
            
            return description
        }
        
        
    }
    
    
    enum Request: Error {
        case NoURLFound(in: URLRequest)
        case ToJSONConversionFailed(from: Any)
        
        var localizedDescriptionVerbose: String {
            let description = String(describing: self) + " " + localizedDescription
            return description
        }
        
        var localizedDescription: String {
            var description : String
            switch self {
                
            case .NoURLFound(let urlRequest):
                description = "No url found in URLRequest: \(urlRequest)"
                
            case .ToJSONConversionFailed(let json):
                description = "Failed to convert to JSON: \(json)"
                
            }
            
            return description
        }
        
    }
    
}
