//
//  CustomActivityIndicatorView.swift
//  CustomViews
//
//  Created by Shobhit Gupta on 19/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit
import QuartzCore


@IBDesignable open class CustomActivityIndicatorView: UIView {
    
    lazy fileprivate var animationLayer = {
        return CALayer()
    }()
    
    
    var isAnimating = false
    
    @IBInspectable public var hidesWhenStopped: Bool = false
    
    @IBInspectable public var rotateClockwise: Bool = true {
        didSet {
            configureRotation(forLayer: animationLayer)
        }
    }
    
    @IBInspectable public var image: UIImage? {
        didSet {
            if let image = image {
                frame.size = image.size
                invalidateIntrinsicContentSize()
                configureAnimationLayer(with: image)
                //pause(layer: animationLayer)
            }
        }
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    public convenience init(with image: UIImage, origin: CGPoint = CGPoint(x: 0, y: 0)) {
        self.init(frame: CGRect(origin: origin, size: image.size))
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
    
    func commonInit() {
        isHidden = false
        layer.addSublayer(animationLayer)
    }
    
    
    override open var intrinsicContentSize: CGSize {
        return image?.size ?? CGSize(width: 0.0, height: 0.0)
    }
    
    
}


public extension CustomActivityIndicatorView {
    
    func configureAnimationLayer(with image: UIImage) {
        animationLayer.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: intrinsicContentSize)
        //        animationLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        animationLayer.contents = image.cgImage
        animationLayer.masksToBounds = true
        configureRotation(forLayer: animationLayer)
        if !isAnimating {
            stopAnimating()
        }
    }
    
    
    func configureRotation(forLayer layer: CALayer) {
        
        layer.removeAnimation(forKey: "rotate")
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = Float.greatestFiniteMagnitude
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = rotateClockwise ? NSNumber(value: Float(0.0)) : NSNumber(value: Float(.pi * 2.0))
        rotation.toValue = rotateClockwise ? NSNumber(value: Float(.pi * 2.0)) : NSNumber(value: Float(0.0))
        
        layer.add(rotation, forKey: "rotate")
        
    }
    
    
}


public extension CustomActivityIndicatorView {
    
    func pause(layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        
        isAnimating = false
    }
    
    
    func resume(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        isAnimating = true
    }
    
    
    func startAnimating() {
        guard !isAnimating else {
            return
        }
        
        if hidesWhenStopped {
            isHidden = false
        }
        
        resume(layer: animationLayer)
    }
    
    
    func stopAnimating() {
        if hidesWhenStopped {
            isHidden = true
        }
        pause(layer: animationLayer)
    }
    
    
}


