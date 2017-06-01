//
//  OTMModel.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 30/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


class OTMModel {
    
    public static let shared = OTMModel()
    
    var student: Udacity.Student?
    var students: [Udacity.Student]  = [] {
        didSet {
            let notification = Notification(name: Notification.Name(rawValue: Default.Notification.StudentsLocationModified.rawValue))
            NotificationCenter.default.post(notification)
        }
    }
    
    private init() {}
    
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
                print("\(student.uniqueKey): \(student.firstName) \(student.lastName)")
                completion(true, nil)
                
            }
            
        }

    }
    
    
    public func logout(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Udacity.logout(completion: completion)
    }
    
    
    public func getSignUpURL() -> URL? {
        return Udacity.getSignUpURL()
    }
    
    
    public func getStudentsLocation(completion: @escaping (_ result: Bool, _ error: Error?) -> Void) {
        
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
    
    
    public func postStudentLocation(completion: @escaping (_ result: Bool, _ error: Error?) -> Void) {
        guard let student = student else {
            completion(false, Error_.App.UserDetailsMissing)
            return
        }
        Udacity.postStudentLocation(of: student, completion: completion)
    }
    
}





