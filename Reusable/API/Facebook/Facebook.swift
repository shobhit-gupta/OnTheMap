//
//  Facebook.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 04/06/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import FacebookCore


public struct Facebook {

    public static func logoutFromFacebook(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        struct LogoutRequest: GraphRequestProtocol {
            
            struct Response: GraphResponseProtocol {
                init(rawResponse: Any?) {
                    // Decode JSON from rawResponse into other properties here.
                }
            }
            
            var graphPath = ""
            var parameters: [String : Any]? = nil
            var accessToken = AccessToken.current
            var httpMethod: GraphRequestHTTPMethod = .DELETE
            var apiVersion: GraphAPIVersion = .defaultVersion
            
            init?() {
                guard let userId = AccessToken.current?.userId else {
                    return nil
                }
                graphPath = "/\(userId)/permissions"
            }
            
        }
        
        guard let request = LogoutRequest() else {
            completion(false, Error_.Facebook.GraphRequest(request: LogoutRequest.self))
            return
        }
        
        let connection = GraphRequestConnection()
        
        
        connection.add(request) { (response, result) in
            switch result {
            case .success:
                completion(true, nil)
                
            case .failed(let error):
                completion(false, error)
            }
        }
        
        connection.start()
    }
    
}
