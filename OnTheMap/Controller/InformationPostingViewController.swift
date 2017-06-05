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
    
    // MARK: IBOutlets
    @IBOutlet weak var addLinkStackView: UIStackView!
    @IBOutlet weak var addLocationStackView: UIStackView!
    @IBOutlet weak var overlaySubmitStackView: UIStackView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var submitAddress: UIButton!
    @IBOutlet weak var submitLink: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var busyView: BusyView!
    
    
    // MARK: Private variables and types
    fileprivate enum InformationPostingState {
        case addLocation
        case busy(title: String?, subtitle: String?)
        case addLink(forMapString: String, latitude: Double, longitude: Double)
    }
    
    
    fileprivate var currentState: InformationPostingState = .addLocation {
        didSet {
            updateUI(to: currentState)
        }
    }
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: IBActions
    @IBAction func findOnMap(_ sender: Any) {
        if let address = addressTextField.text {
            currentState = .busy(title: Default.BusyView.LookingUpAddress.Title,
                                 subtitle: Default.BusyView.LookingUpAddress.Subtitle)
            CLGeocoder().geocodeAddressString(address, completionHandler: forwardGeocoded(placemarks:error:))
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss()
    }
    
    
    @IBAction func submit(_ sender: Any) {
        guard case InformationPostingState.addLink(let mapString, let latitude, let longitude) = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").info())
            return
        }
        
        guard let text = linkTextField.text,
            let url = URL(string: text) else {
                present(Error_.App.BadURL(urlString: linkTextField.text).alertController(), animated: true, completion: nil)
                return
        }
        
        OTMModel.shared.student?.mapString = mapString
        OTMModel.shared.student?.latitude = latitude
        OTMModel.shared.student?.longitude = longitude
        OTMModel.shared.student?.mediaURL = url
        
        currentState = .busy(title: Default.BusyView.PostStudentLocation.Title,
                             subtitle: Default.BusyView.PostStudentLocation.Subtitle)
        
        OTMModel.shared.postStudentLocation { (success, error) in
            guard success else {
                if let error = error {
                    self.present(error.alertController(), animated: true, completion: nil)
                }
                return
            }
            Default.Notification_.StudentsLocationRefreshRequested.post()
            self.dismiss(animated: true, completion: nil)
        }
        
    }

}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension InformationPostingViewController {
    
    fileprivate func setupUI() {
        setupView()
        setupAddressLabel()
        setupTextFields()
        setupButtons()
    }
    
    
    private func setupView() {
        view.backgroundColor = ArtKit.backgroundColor
    }
    
    
    private func setupAddressLabel() {
        addressLabel.textColor = Default.InfoPostingView.Address.Label.Text.Color
        addressLabel.numberOfLines = Default.InfoPostingView.Address.Label.NumberOfLines
        addressLabel.textAlignment = Default.InfoPostingView.Address.Label.Text.Alignment
        
        let attributes: [String : Any] = [
            NSFontAttributeName : Default.InfoPostingView.Address.Label.Font,
            NSForegroundColorAttributeName : Default.InfoPostingView.Address.Label.Text.Color
        ]
        
        let addressLabelString = NSMutableAttributedString(string: Default.InfoPostingView.Address.Label.Text.Value, attributes: attributes)
        addressLabelString.addAttribute(NSFontAttributeName,
                                        value: Default.InfoPostingView.Address.Label.StressedFont,
                                        range: Default.InfoPostingView.Address.Label.StressedRange)
        
        addressLabel.attributedText = addressLabelString
    }
    
    
    private func setupTextFields() {
        [addressTextField, linkTextField].forEach {
            setupTextField($0)
        }
        
        let shadow = NSShadow()
        shadow.shadowOffset = Default.InfoPostingView.TextField.Placeholder.Shadow.Offset
        shadow.shadowBlurRadius = Default.InfoPostingView.TextField.Placeholder.Shadow.BlurRandius
        
        let placeholderAttributes: [String : Any] = [
            NSForegroundColorAttributeName : Default.InfoPostingView.TextField.Placeholder.TextColor,
            NSShadowAttributeName : shadow
        ]
        
        addressTextField.becomeFirstResponder()
        addressTextField.attributedPlaceholder = NSAttributedString(string: Default.InfoPostingView.Address.Placeholder,
                                                                    attributes: placeholderAttributes)
        linkTextField.attributedPlaceholder = NSAttributedString(string: Default.InfoPostingView.Link.Placeholder,
                                                                 attributes: placeholderAttributes)
    }
    
    
    private func setupTextField(_ textField: UITextField) {
        textField.backgroundColor = Default.InfoPostingView.TextField.BackgroundColor
        textField.textColor = Default.InfoPostingView.TextField.TextColor
        textField.keyboardAppearance = Default.InfoPostingView.TextField.KeyboardAppearance
    }
    
    
    private func setupButtons() {
        [submitAddress, submitLink].forEach {
            setupButton($0)
        }
        cancelButton.setTitleColor(Default.InfoPostingView.Button.Cancel.Color.Normal, for: .normal)
    }
    
    
    private func setupButton(_ button: UIButton) {
        button.setTitleColor(Default.InfoPostingView.Button.Color.Normal, for: .normal)
        button.setTitleColor(Default.InfoPostingView.Button.Color.Highlighted, for: .highlighted)
    }
    
    
    fileprivate func dismiss() {
        [addressTextField, linkTextField].forEach {
            $0?.resignFirstResponder()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func updateUI(to state: InformationPostingState) {
        
        switch state {
        case .addLocation:
            busyView.dismiss()
            UIView.fade(out: addLinkStackView, andHide: true, thenFadeIn: addLocationStackView)
            UIView.transition(with: self.cancelButton,
                              duration: 2.0,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.cancelButton.setTitleColor(ArtKit.shadowOfSecondaryColor, for: .normal)
            }, completion: nil)
            
            overlaySubmitStackView.fadeOut { _ in
                self.overlaySubmitStackView.isHidden = true
            }
            
            addressTextField.becomeFirstResponder()
            
        case .addLink:
            busyView.dismiss()
            UIView.fade(out: addLocationStackView, andHide: true, thenFadeIn: addLinkStackView)
            self.overlaySubmitStackView.fadeIn(duration: 1.0)
            UIView.transition(with: self.cancelButton,
                              duration: 1.0,
                              options: .transitionCrossDissolve,
                              animations: { self.cancelButton.setTitleColor(ArtKit.shadowOfSecondaryColor, for: .normal) }) { _ in
                self.linkTextField.becomeFirstResponder()
            }
            
        case let .busy(title, subtitle):
            addressTextField.resignFirstResponder()
            linkTextField.resignFirstResponder()
            busyView.title = title
            busyView.subtitle = subtitle
            busyView.present()
            
        }
        
    }
    
    
}


//******************************************************************************
//                              MARK: Geocoding
//******************************************************************************
extension InformationPostingViewController {
    
    func forwardGeocoded(placemarks: [CLPlacemark]?, error: Error?) -> Void {
        guard error == nil else {
            currentState = .addLocation
            if let error = error {
                present(error.alertController(), animated: true, completion: nil)
            }
            return
        }
        
        guard let placemark = placemarks?[0],
            let coordinates = placemark.location?.coordinate else {
                currentState = .addLocation
                present(Error_.App.AddressNotFound.alertController(), animated: true, completion: nil)
                return
        }
        
        if let address = addressTextField.text,
            let annotation = OTMMapViewAnnotation(with: [.title: address, .coordinate:coordinates]) {
            currentState = .addLink(forMapString: placemark.name ?? address, latitude: coordinates.latitude, longitude: coordinates.longitude)
            mapView.showAnnotations([annotation], animated: true)
        }
        
    }
    
}


//******************************************************************************
//                              MARK: UITextField
//******************************************************************************
extension InformationPostingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addressTextField {
            findOnMap(textField)
        } else if textField === linkTextField{
            submit(textField)
        }
        return true
    }
    
}







