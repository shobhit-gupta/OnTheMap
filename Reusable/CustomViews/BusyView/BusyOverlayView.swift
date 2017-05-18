//
//  BusyOverlayView.swift
//  CustomViews
//
//  Created by Shobhit Gupta on 22/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

@IBDesignable open class BusyOverlayView: UIView {

    @IBOutlet var contentView: UIView!
    
    // Custom indicators
    @IBOutlet weak public var loadingIndicator: CustomActivityIndicatorView!
    @IBOutlet weak public var pinIndicator: CustomActivityIndicatorView!
    
    // Labels
    @IBOutlet weak public var title: UILabel!
    @IBOutlet weak public var subtitle: UILabel!
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        Bundle(for: type(of: self)).loadNibNamed("BusyOverlayView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }

}
