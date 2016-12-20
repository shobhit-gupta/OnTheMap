//
//  UIView - Fadeable.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 17/12/16.
//


import Foundation
import UIKit


extension UIView {

    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        if self.isHidden {
            self.alpha = 0.0
            self.isHidden = false
        }
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
        
    }
    
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    
    class func fade(out outView: UIView, andHide shouldHide: Bool = true, thenFadeIn inView: UIView, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        outView.fadeOut { _ in
            outView.isHidden = shouldHide
            inView.fadeIn(completion: completion)
        }
        
    }
    
}
