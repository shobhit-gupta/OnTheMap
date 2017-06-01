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
        case addLink(forMapString: String, latitude: Double, longitude: Double)
    }
    

    @IBOutlet weak var addLinkStackView: UIStackView!
    @IBOutlet weak var addLocationStackView: UIStackView!
    @IBOutlet weak var overlaySubmitStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
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
            busyView.dismiss()
            UIView.fade(out: addLinkStackView, andHide: true, thenFadeIn: addLocationStackView)
            UIView.transition(with: self.cancelButton, duration: 2.0, options: .transitionCrossDissolve, animations: { self.cancelButton.setTitleColor(UIColor(netHex: 0x325075), for: .normal) }, completion: nil)
            overlaySubmitStackView.fadeOut { _ in
                self.overlaySubmitStackView.isHidden = true
            }
            
        case .addLink:
            busyView.dismiss()
            UIView.fade(out: addLocationStackView, andHide: true, thenFadeIn: addLinkStackView) { _ in
            }
            self.overlaySubmitStackView.fadeIn(duration: 2.0)
            UIView.transition(with: self.cancelButton, duration: 2.0, options: .transitionCrossDissolve, animations: { self.cancelButton.setTitleColor(UIColor.white, for: .normal) }, completion: nil)
            
        case .busy:
            busyView.present()
            
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
        guard case InformationPostingState.addLink(let mapString, let latitude, let longitude) = currentState else {
            return
        }
        
        guard linkTextField.hasText else {
            return
        }
        
        guard let url = URL(string: linkTextField.text!) else {
            return
        }
        
        OTMModel.shared.student?.mapString = mapString
        OTMModel.shared.student?.latitude = latitude
        OTMModel.shared.student?.longitude = longitude
        OTMModel.shared.student?.mediaURL = url
        
        currentState = .busy
        
        OTMModel.shared.postStudentLocation { (success, error) in
            guard success else {
                if let error = error {
                    self.present(error.alertController(), animated: true, completion: nil)
                }
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        }
    }

}


extension InformationPostingViewController {
    
    func forwardGeocoded(placemarks: [CLPlacemark]?, error: Error?) -> Void {
        // TODO: Present an alert view for user in case of an error
        guard error == nil else {
            currentState = .addLocation
            if let error = error {
                present(error.alertController(), animated: true, completion: nil)
            }
            //print(error!.localizedDescription)
            return
        }
        
        guard let placemark = placemarks?[0],
            let coordinates = placemark.location?.coordinate else {
                currentState = .addLocation
                present(Error_.App.AddressNotFound.alertController(), animated: true, completion: nil)
                //print("Couldn't find the address!")
                return
        }
        
        if let address = addressTextField.text,
            let annotation = OTMMapViewAnnotation(with: [.title: address, .coordinate:coordinates]) {
            currentState = .addLink(forMapString: placemark.name ?? address, latitude: coordinates.latitude, longitude: coordinates.longitude)
            mapView.showAnnotations([annotation], animated: true)
        }
        
    }
    
}


