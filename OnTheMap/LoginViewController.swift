//
//  ViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 06/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beautifyView()
    }
    

    @IBAction func signIn(_ sender: Any) {
        // TODO: 
        // 1. Perform Sign In
        // 2. If successful, perform segue to Map and Table Tabbed View
        // 3. If not, present alert view specifying whether it was
        //      3.1. a failed network connection
        //      3.2. an incoorect email or password
        performSegue(withIdentifier: "ShowMapTableTabbedView", sender: nil)
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func hasUserGivenRequiredInfo() -> Bool {
        return emailTextField.hasText && passwordTextField.hasText
    }
    
}


extension LoginViewController {
    
    func beautifyView() {
        rootStackView.separatorColor = ViewConstants.StackView.Separator.color
        rootStackView.separatorThickness = ViewConstants.StackView.Separator.thickness
    }
    
    
    override func viewDidLayoutSubviews() {
        rootStackView.separatorLength = (rootStackView.axis == .vertical ? rootStackView.frame.width : rootStackView.frame.height) - 40
    }
    
}



extension LoginViewController: OrderedViewsForKeyboard {
    
    var viewTags: CountableClosedRange<Int> {
        return 1...2
    }
    
    var containingView: UIView {
        return view
    }
    
    
    func haveValidInputForView(withTag tag: Int) -> Bool {
        switch tag {
        case 1:
            return emailTextField.hasText
        case 2:
            return passwordTextField.hasText
        default:
            return false
        }
        
    }


}



extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return viewShouldReturn(textField) { (view) in
            self.signIn(view)
        }
    }
    
}
