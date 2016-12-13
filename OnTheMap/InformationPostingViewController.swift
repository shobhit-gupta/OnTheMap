//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 12/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit
import MapKit


class InformationPostingViewController: UIViewController {
    
    enum InformationPostingState {
        case addLocation
        case addLink
    }
    

    @IBOutlet weak var addLinkStackView: UIStackView!
    @IBOutlet weak var addLocationStackView: UIStackView!
    @IBOutlet weak var overlaySubmitStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(to: .addLocation)
    }
    
    
    func updateUI(to state: InformationPostingState) {
        
        switch state {
        case .addLocation:
            addLocationStackView.isHidden = false
            addLinkStackView.isHidden = true
            overlaySubmitStackView.isHidden = true
            cancelButton.setTitleColor(UIColor(netHex: 0x325075), for: .normal)
            
        case .addLink:
            addLocationStackView.isHidden = true
            addLinkStackView.isHidden = false
            overlaySubmitStackView.isHidden = false
            cancelButton.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    

    @IBAction func findOnMap(_ sender: Any) {
        updateUI(to: .addLink)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submit(_ sender: Any) {
        // TODO: Check if input is valid and submit to server
    }

}
