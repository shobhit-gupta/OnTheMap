//
//  OTMModel.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 30/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


class OTMModel: NSObject {
    
    public static let shared = OTMModel()
    
    public enum LoginMethod {
        case udacity
        case google
    }
    
    public var loginMethod: LoginMethod? {
        get { return _loginMethod }
        set {
            guard _loginMethod == nil || newValue == nil else {
                fatalError("Trying to login while already logged in")
            }
            _loginMethod = newValue
        }
    }
    
    public var student: Udacity.Student?
    public var students: [Udacity.Student]  = [] {
        didSet {
            Default.Notification_.StudentsLocationModified.post()
        }
    }

    public private(set) var isGoogleSignInAvailable = false
    
    
    fileprivate var loginCompletionHandler: ((_ success: Bool, _ error: Error?) -> Void)?
    fileprivate var logoutCompletionHandler: ((_ success: Bool, _ error: Error?) -> Void)?
    
    private var _loginMethod: LoginMethod?
    
    private override init() {
        super.init()
        isGoogleSignInAvailable = configureGGLContext()
    }
    
}


extension OTMModel {

    public func logout(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        if loginMethod == .udacity {
            logoutFromUdacity(completion: completion)
            
        } else if loginMethod == .google {
            logoutFromGoogle(completion: completion)
        }
    }
    
}


//******************************************************************************
//                            MARK: Udacity API
//******************************************************************************
extension OTMModel {
    
    public func login(userName: String,
                      password: String,
                      completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        Udacity.login(userName: userName, password: password) { (success, userKey, error) in
            
            guard success, let userKey = userKey else {
                completion(false, error)
                return
            }
            
            Udacity.studentInfo(for: userKey) { (success, student, error) in
                
                guard success, let student = student else {
                    completion(false, error)
                    return
                }
                
                self.student = student
                self.loginMethod = .udacity
                completion(true, nil)
                
            }
            
        }

    }
    
    
    fileprivate func logoutFromUdacity(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Udacity.logout { (success, error) in
            if success {
                self.loginMethod = nil
            }
            completion(success, error)
        }
    }
    
    
    public func getSignUpURL() -> URL? {
        return Udacity.getSignUpURL()
    }
    
    
    public func getStudentsLocation(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        Udacity.getStudentsLocation { (success, students, error) in
            
            guard success, let students = students else {
                completion(false, error)
                return
            }
            
            self.students = students
            completion(true, nil)
            return
            
        }
        
    }
    
    
    public func postStudentLocation(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let student = student else {
            completion(false, Error_.App.UserDetailsMissing)
            return
        }
        Udacity.postStudentLocation(of: student, completion: completion)
    }
    
}


//******************************************************************************
//                            MARK: Google SignIn
//******************************************************************************
extension OTMModel: GIDSignInDelegate {
    
    public func loginWithGoogle(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        loginCompletionHandler = completion
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    fileprivate func logoutFromGoogle(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        logoutCompletionHandler = completion
        GIDSignIn.sharedInstance().disconnect()
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            loginCompletionHandler?(false, error)
            return
        }
        
        student = Udacity.Student(uniqueKey: user.userID, firstName: user.profile.givenName, lastName: user.profile.familyName)
        loginMethod = .google
        loginCompletionHandler?(true, nil)
        
        defer { 
            loginCompletionHandler = nil
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            logoutCompletionHandler?(false, error)
            return
        }
        
        loginMethod = nil
        logoutCompletionHandler?(true, nil)
        
        defer {
            logoutCompletionHandler = nil
        }
    }
    
    
    
}




