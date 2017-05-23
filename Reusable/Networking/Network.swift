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

    public class func asyncDataTask(with urlRequest: URLRequest,
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
            
            // Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                case 200...299 = statusCode else {
                    completion(nil, Error_.Network.Response.UnsuccessfulStatusCode(url: url))
                    return
            }
            
            // Was there any data returned?
            guard let _ = data else {
                completion(nil, Error_.Network.Response.NoData(url: url))
                return
            }
            
        }.resume()
        
    }
    
}


//******************************************************************************
//                              MARK: Get
//******************************************************************************
public extension Network {
    
    public class func asyncGetData(from url: URL,
                             completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        return asyncDataTask(with: URLRequest(url: url), completion: completion)
        
    }
    
    
    public class func asyncGetImage(from url: URL,
                              completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        asyncGetData(from: url) { (data, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image, nil)
                } else {
                    completion(nil, Error_.Network.Response.NotAnImage(url: url))
                }
            }
        }
    }
    
    
    public class func asyncGetJSON(from url: URL,
                                   options opt: JSONSerialization.ReadingOptions = [],
                                   completion: @escaping (_ json: Any?, _ error: Error?) -> Void) {
        asyncGetData(from: url) { (data, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
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
    
    
}


public extension Default.Network {
    
}




public extension Error_.Network {
    enum Response: Error {
        case NoData(url: URL)
        case UnsuccessfulStatusCode(url: URL)
        case NotAnImage(url: URL)
        case InvalidJSON(url: URL, data: Data?)
        
        var localizedDescription: String {
            var description = String(describing: self)
            switch self {
                
            case .NoData(let url):
                description += "No data was returned by: \(url)"
                
            case .UnsuccessfulStatusCode(let url):
                description += "Other than 2xx status code returned by: \(url)"
                
            case .NotAnImage(let url):
                description += "Can't construct an image from the data returned by: \(url)"
                
            case let .InvalidJSON(url, data):
                description += "Can't construct JSON from the data returned by: \(url)"
                if let data = data {
                    description += "\nData Returned: \(data)"
                }
            }
            
            return description
        }
        
    }
    
    
    enum Request: Error {
        case NoURLFound(in: URLRequest)
        case ToJSONConversionFailed(from: Any)
        
        var localizedDescription: String {
            var description = String(describing: self)
            switch self {
                
            case .NoURLFound(let urlRequest):
                description += "No url found in URLRequest: \(urlRequest)"
                
            case .ToJSONConversionFailed(let json):
                description += "Failed to convert to JSON: \(json)"
            
            }
            
            return description
        }
        
    }
        
}
