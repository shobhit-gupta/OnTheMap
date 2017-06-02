//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 31/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    fileprivate enum State {
        case alert(error: Error)
        case normal
    }
    
    fileprivate var currentState: State = .normal {
        didSet {
            updateUI()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshStudentsLocation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromNotification()
    }

    
}


extension TabBarController {
    
    fileprivate func refreshStudentsLocation() {
        OTMModel.shared.getStudentsLocation { (success, error) in
            guard success else {
                if let error = error {
                    DispatchQueue.main.async {
                        self.currentState = .alert(error: error)
                    }
                }
                return
            }
        }
    }
    
    
    fileprivate func updateUI() {
        switch currentState {
        case .alert(let error):
            present(error.alertController(), animated: true, completion: nil)
        case .normal:
            break
        }
    }
    
}



//******************************************************************************
//                              MARK: Notifications
//******************************************************************************
extension TabBarController {
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(studentsLocationRefreshRequested(_:)),
                                               name: Notification.Name(rawValue: Default.Notification_.StudentsLocationRefreshRequested.rawValue),
                                               object: nil)
    }
    
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func studentsLocationRefreshRequested(_ notification: Notification) {
        refreshStudentsLocation()
    }
    
    
}
