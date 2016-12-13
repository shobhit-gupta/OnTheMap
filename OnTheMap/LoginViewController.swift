//
//  ViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 06/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        beautifyView()
        
    }
    

    @IBAction func signIn(_ sender: Any) {
        performSegue(withIdentifier: "ShowMapTableTabbedView", sender: nil)
    }
    
    
}


extension LoginViewController {
    
    func beautifyView() {
        mainStackView.separatorColor = ViewConstants.StackView.Separator.color
        mainStackView.separatorThickness = ViewConstants.StackView.Separator.thickness
    }
    
    
    override func viewDidLayoutSubviews() {
        mainStackView.separatorLength = (mainStackView.axis == .vertical ? mainStackView.frame.width : mainStackView.frame.height) - 40
    }
    
}


extension LoginViewController {
    
    
}
