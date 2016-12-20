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

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var currentState: InformationPostingState = .addLocation {
        didSet {
            updateUI(to: currentState)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func updateUI(to state: InformationPostingState) {
        
        switch state {
        case .addLocation:
            UIView.fade(out: addLinkStackView, andHide: true, thenFadeIn: addLocationStackView)
            UIView.transition(with: self.cancelButton, duration: 2.0, options: .transitionCrossDissolve, animations: { self.cancelButton.setTitleColor(UIColor(netHex: 0x325075), for: .normal) }, completion: nil)
            overlaySubmitStackView.fadeOut { _ in
                self.overlaySubmitStackView.isHidden = true
            }
            
        case .addLink:
            UIView.fade(out: addLocationStackView, andHide: true, thenFadeIn: addLinkStackView) { _ in
            }
            self.overlaySubmitStackView.fadeIn(duration: 2.0)
            UIView.transition(with: self.cancelButton, duration: 2.0, options: .transitionCrossDissolve, animations: { self.cancelButton.setTitleColor(UIColor.white, for: .normal) }, completion: nil)
            
        }
        
    }
    

    @IBAction func findOnMap(_ sender: Any) {
        if let address = addressTextField.text {
            CLGeocoder().geocodeAddressString(address, completionHandler: forwardGeocoded(placemarks:error:))
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submit(_ sender: Any) {
        // TODO: Check if input is valid and submit to server
        currentState = .addLocation
    }

}


extension InformationPostingViewController {
    
    func forwardGeocoded(placemarks: [CLPlacemark]?, error: Error?) -> Void {
        
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        guard let placemarks = placemarks,
            let coordinates = placemarks[0].location?.coordinate else {
                print("Couldn't find the address!")
                return
        }
        
        if let address = addressTextField.text,
            let annotation = OTMMapViewAnnotation(with: [.title: address, .coordinate:coordinates]) {
            currentState = .addLink
            mapView.showAnnotations([annotation], animated: true)
        }
        
    }
    
    
}

