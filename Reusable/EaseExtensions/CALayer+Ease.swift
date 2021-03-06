//
//  CALayer+Ease.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 14/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation


extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
