//
//  OrderedViewsForKeyboard.swift
//  CustomViews
//
//  Created by Shobhit Gupta on 16/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public protocol OrderedViewsForKeyboard {
    var viewTags: CountableClosedRange<Int> { get }
    var containingView: UIView { get }
    func haveValidInputForView(withTag tag: Int) -> Bool
    func viewShouldReturn(_ view: UIView, completionHandler: ((_ sender: UIView) -> Void)? ) -> Bool
}


public extension OrderedViewsForKeyboard {
    func shouldBeFirstResponder(withTag tag: Int) -> Bool {
        if viewTags ~= tag {
            return !haveValidInputForView(withTag: tag)
        }
        return false
    }
}


public extension OrderedViewsForKeyboard {
    
    func getView(withTag tag: Int) -> UIView? {
        return containingView.viewWithTag(tag)
    }
    
    
    func getNextView(toTag tag: Int) -> UIView? {
        if tag < viewTags.upperBound {
            return getView(withTag: tag + 1)
        }
        
        for i in viewTags {
            if shouldBeFirstResponder(withTag: i) {
                return getView(withTag: i)
            }
        }
        
        return nil
        
    }
    
    
    func viewShouldReturn(_ view: UIView, completionHandler: ((_ sender: UIView) -> Void)? ) -> Bool {
        if haveValidInputForView(withTag: view.tag) {
            view.resignFirstResponder()
            if let nextView = getNextView(toTag: view.tag) {
                nextView.becomeFirstResponder()
            } else if let completionHandler = completionHandler {
                DispatchQueue.main.async { () -> Void in
                    completionHandler(view)
                }
            }
            return true
        }
        
        return false
    }
    
}
