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
        case busy
        case addLink
    }
    

    @IBOutlet weak var addLinkStackView: UIStackView!
    @IBOutlet weak var addLocationStackView: UIStackView!
    @IBOutlet weak var overlaySubmitStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var busyView: BusyView!
    
    
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
            dismissAlert()
            UIView.fade(out: addLinkStackView, andHide: true, thenFadeIn: addLocationStackView)
            UIView.transition(with: self.cancelButton, duration: 2.0, options: .transitionCrossDissolve, animations: { self.cancelButton.setTitleColor(UIColor(netHex: 0x325075), for: .normal) }, completion: nil)
            overlaySubmitStackView.fadeOut { _ in
                self.overlaySubmitStackView.isHidden = true
            }
            
        case .addLink:
            dismissAlert()
            UIView.fade(out: addLocationStackView, andHide: true, thenFadeIn: addLinkStackView) { _ in
            }
            self.overlaySubmitStackView.fadeIn(duration: 2.0)
            UIView.transition(with: self.cancelButton, duration: 2.0, options: .transitionCrossDissolve, animations: { self.cancelButton.setTitleColor(UIColor.white, for: .normal) }, completion: nil)
            
        case .busy:
            presentAlert()
            
        }
        
    }
    

    @IBAction func findOnMap(_ sender: Any) {
        if let address = addressTextField.text {
            currentState = .busy
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
        // TODO: Present an alert view for user in case of an error
        guard error == nil else {
            currentState = .addLocation
            print(error!.localizedDescription)
            return
        }
        
        guard let placemarks = placemarks,
            let coordinates = placemarks[0].location?.coordinate else {
                currentState = .addLocation
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


extension InformationPostingViewController {
    
    func dismissAlert(){
        if !busyView.isHidden {
            busyView.outerIndicator.stopAnimating()
            busyView.innerIndicator.stopAnimating()
            busyView.isHidden = true
        }
    }
    
    
    func presentAlert() {
        busyView.outerIndicator.startAnimating()
        busyView.innerIndicator.startAnimating()
        busyView.isHidden = false
    }
    
}
