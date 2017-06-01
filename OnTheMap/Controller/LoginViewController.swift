//
//  ViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 06/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: Private variables and types
    fileprivate enum State {
        case alert(error: Error)
        case busy(title: String?, subtitle: String?)
        case normal
    }
    
    fileprivate var currentState: State = .normal {
        didSet {
            updateUI()
        }
    }
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewDidLayoutSubviews() {
        rootStackView.separatorLength = (rootStackView.axis == .vertical ? rootStackView.frame.width : rootStackView.frame.height) - (2 * Default.StackView.Separator.Padding)
    }
    

    // MARK: IBActions
    @IBAction func signIn(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            // Get rid of keyboard if it still showing
            hideKeyboard()
            
            OTMModel.shared.login(userName: email, password: password, completion: { (success, error) in
                
                guard success else {
                    if let error = error {
                        self.currentState = .alert(error: error)
                    }
                    return
                }
                
                self.performSegue(withIdentifier: Default.Segues.FromLogin.ToTabbedView.rawValue, sender: nil)
                
            })
        }
        
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        if let url = OTMModel.shared.getSignUpURL() {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension LoginViewController {
    
    fileprivate func setupUI() {
        setupStackView()
    }
    
    
    private func setupStackView() {
        rootStackView.separatorColor = Default.StackView.Separator.Color
        rootStackView.separatorThickness = Default.StackView.Separator.Thickness
    }
    
    
    fileprivate func updateUI() {
        switch currentState {
        case .alert(let error):
            present(error.alertController(), animated: true, completion: nil)
            
        case let .busy(title, subtitle):
            break
            
        case .normal:
            break
            
        }
        
    }
    
    
}


//******************************************************************************
//               MARK: OrderedViewsRespondToReturnKey Protocol
//******************************************************************************
extension LoginViewController: OrderedViewsRespondToReturnKey {
    
    var viewTags: CountableClosedRange<Int> {
        return 1...2
    }
    
    var containingView: UIView {
        return view
    }
    
    
    func orderedViewsCompletionHandler() {
        signIn(self)
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


//******************************************************************************
//                              MARK: UITextField
//******************************************************************************
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return viewShouldReturn(textField)
    }
    
}


extension LoginViewController {
    
    fileprivate func hasUserGivenRequiredInfo() -> Bool {
        return emailTextField.hasText && passwordTextField.hasText
    }
    
    
    fileprivate func hideKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
