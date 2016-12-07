//
//  ViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 06/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var headerStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        headerStackView.separatorColor = ViewConstants.StackView.Separator.color
        headerStackView.separatorThickness = ViewConstants.StackView.Separator.thickness
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidLayoutSubviews() {
        headerStackView.separatorLength = (headerStackView.axis == .vertical ? headerStackView.frame.width : headerStackView.frame.height) - 40
    }

}

