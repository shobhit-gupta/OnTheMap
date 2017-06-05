//
//  Facebook.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 04/06/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin


public struct Facebook {

    
    public static func loginWithFacebook(viewController: UIViewController,
                                         permissions: [ReadPermission] = [.publicProfile],
                                         completion: @escaping (_ success: Bool,
                                                                _ grantedPermissions: Set<Permission>?,
                                                                _ declinedPermissions: Set<Permission>?,
                                                                _ token: AccessToken?,
                                                                _ error: Error?) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions, viewController: viewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                completion(false, nil, nil, nil, error)
                
            case .cancelled:
                completion(false, nil, nil, nil, Error_.Facebook.LoginCanceled)
                
            case let .success(grantedPermissions, declinedPermissions, token):
                completion(true, grantedPermissions, declinedPermissions, token, nil)
                
            }
        }
        
    }
    
    
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


public extension Error_ {
    
    enum Facebook: Error {
        case GraphRequest(request: Any.Type)
        case LoginCanceled
        case PermissionDenied(permission: ReadPermission)
        
        var localizedDescription: String {
            var description : String
            switch self {
            case .GraphRequest(let requestType):
                description = "Could not initialize graph request: \(requestType)"
                
            case .LoginCanceled:
                description = "User canceled login."
                
            case .PermissionDenied(let permission):
                description = "Denied permission: \(permission)"
                
            }
            
            return description
        }
    }
    
}
