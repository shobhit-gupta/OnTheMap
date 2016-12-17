//
//  OrderedViewsForKeyboard.swift
//  CustomViews
//
//  Created by Shobhit Gupta on 16/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit

// Protocol for the conforming class to have subviews that are ordered by tags.
// This order is used to determine the first responder behaviour of the subviews
// for responding to the return key.
public protocol OrderedViewsRespondToReturnKey {
    
    // REQUIRED: Range for the view tags that the ordered views have.
    var viewTags: CountableClosedRange<Int> { get }
    
    // REQUIRED: The super view that has the ordered views.
    var containingView: UIView { get }
    
    
    // REQUIRED: Usually validation for a UITextField or UITextView takes place
    // in the delegate's shouldEndEditing method. But, we use this method for
    // ordered subviews to have the desired effect of cycling back to the
    // subview that requires user's input after the user provided the input for
    // the last subview in the order.
    func haveValidInputForView(withTag tag: Int) -> Bool
    
    // OPTIONAL: Called after the last view in the ordered view resigns as first
    // responder and all the ordered views have valid user input. Do not
    // implement this, and just rely upon the protocol extension below, if there
    // is no need for a completion handler.
    func orderedViewsCompletionHandler()
    
    // OPTIONAL: A closely related method to haveValidInputForView. It's purpose
    // is to provide correct semantics & more control for if an ordered subview
    // should become the first responder even if it already has a valid input
    // from the user. Do not implement this, and just rely upon the protocol
    // extension below, if there isn't any need for such control.
    func shouldBeFirstResponder(withTag tag: Int) -> Bool
    
    // DO NOT IMPLEMENT, JUST CALL: This method should be called from
    // textFieldShouldReturn or textViewShouldChangeTextInRange (if UITextView
    // should resign first reponder status on receiving return key). Do not
    // implement this, and just rely upon the protocol extension below, unless
    // you need something custom or different.
    func viewShouldReturn(_ view: UIView) -> Bool
    
}


// Optional implementation for the protocol.
public extension OrderedViewsRespondToReturnKey {
    func shouldBeFirstResponder(withTag tag: Int) -> Bool {
        if viewTags ~= tag {
            return !haveValidInputForView(withTag: tag)
        }
        return false
    }
}


// Optional implementation for the protocol.
public extension OrderedViewsRespondToReturnKey {
    func orderedViewsCompletionHandler() {
        return
    }
}



// Default implementation that any class can take advantage of.
// ------------------------------------------------------------
// Default behaviour:
// On encountering return key the current subview (UITextField or UITextView or
// any subclass) will be checked to contain a valid input from the user.
// 1. If it doesn't contain a valid input:
//      - Current subview doesn't resign from being the first responder.
// 2. If it does contain a valid input:
//      - It resigns and ask the next subview to become the first responder.
//
// The next sub view is determined by:
// 1. If there is a subview with the next tag value, i.e. (current subview's
//    tag value + 1), then it is the next subview.
// 2. If no such subview exists, then the first subview that doesn't have valid
//    input is the next subview.
// 3. If no such subview exists, i.e. all subviews have valid inputs, then the
//    orderedViewsCompletionHandler method is called.

public extension OrderedViewsRespondToReturnKey {
    
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
    
    
    func viewShouldReturn(_ view: UIView) -> Bool {
        if haveValidInputForView(withTag: view.tag) {
            view.resignFirstResponder()
            if let nextView = getNextView(toTag: view.tag) {
                nextView.becomeFirstResponder()
            } else {
                DispatchQueue.main.async { () -> Void in
                    self.orderedViewsCompletionHandler()
                }
            }
            return true
        }
        
        return false
    }
    
}
