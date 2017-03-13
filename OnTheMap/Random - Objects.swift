//
//  Random - Objects.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 23/02/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension UIColor {
    
    public static func random(withAlpha alpha: CGFloat = 1.0) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
}
