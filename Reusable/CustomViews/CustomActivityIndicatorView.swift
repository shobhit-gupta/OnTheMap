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
    
    @IBInspectable public var hidesWhenStopped: Bool = Default.CustomActivityIndicatorView.HidesWhenStopped
    
    @IBInspectable public var rotateClockwise: Bool = Default.CustomActivityIndicatorView.RotateClockwise {
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
    
    
    public convenience init(with image: UIImage, origin: CGPoint = Default.CustomActivityIndicatorView.Origin) {
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
        return image?.size ?? Default.CustomActivityIndicatorView.IntrinsicContentSize
    }
    
    
}


public extension CustomActivityIndicatorView {
    
    func configureAnimationLayer(with image: UIImage) {
        animationLayer.frame = CGRect(origin: CGPoint.zero, size: intrinsicContentSize)
        animationLayer.contents = image.cgImage
        animationLayer.masksToBounds = true
        configureRotation(forLayer: animationLayer)
        if !isAnimating {
            stopAnimation()
        }
    }
    
    
    func configureRotation(forLayer layer: CALayer) {
        
        layer.removeAnimation(forKey: Default.CustomActivityIndicatorView.Animation.Rotate.Key)
        
        let rotation = CABasicAnimation(keyPath: Default.CustomActivityIndicatorView.Animation.Rotate.KeyPath)
        rotation.duration = Default.CustomActivityIndicatorView.Animation.Rotate.Duration
        rotation.isRemovedOnCompletion = Default.CustomActivityIndicatorView.Animation.Rotate.IsRemovedOnCompletion
        rotation.repeatCount = Default.CustomActivityIndicatorView.Animation.Rotate.RepeatCount
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = rotateClockwise ? Default.Angle.Zero : Default.Angle.TwoPi
        rotation.toValue = rotateClockwise ? Default.Angle.TwoPi : Default.Angle.Zero
        
        layer.add(rotation, forKey: Default.CustomActivityIndicatorView.Animation.Rotate.Key)
        
    }
    
    
}


public extension CustomActivityIndicatorView {
    
    func pause(layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = Default.CustomActivityIndicatorView.Animation.Pause.Speed
        layer.timeOffset = pausedTime
        
        isAnimating = false
    }
    
    
    func resume(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = Default.CustomActivityIndicatorView.Animation.Resume.Speed
        layer.timeOffset = Default.CustomActivityIndicatorView.Animation.Resume.TimeOffset
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        isAnimating = true
    }
    
    
    func startAnimation() {
        guard !isAnimating else {
            return
        }
        
        if hidesWhenStopped {
            isHidden = false
        }
        
        resume(layer: animationLayer)
    }
    
    
    func stopAnimation() {
        if hidesWhenStopped {
            isHidden = true
        }
        pause(layer: animationLayer)
    }
    
    
}


public extension Default {

    enum Angle {
        static let Zero = NSNumber(value: Float(0.0))
        static let Pi = NSNumber(value: Float.pi)
        static let TwoPi = NSNumber(value: Float(.pi * 2.0))
    }
    
    
    enum CustomActivityIndicatorView {
        
        static let HidesWhenStopped = false
        static let RotateClockwise = true
        static let Origin =  CGPoint.zero
        static let IntrinsicContentSize = CGSize.zero
        
        enum Animation {
            
            enum Pause {
                static let Speed: Float = 0.0
            }
            
            enum Resume {
                static let Speed: Float = 1.0
                static let TimeOffset: CFTimeInterval = 0.0
            }
            
            enum Rotate {
                static let Key = "rotate"
                static let KeyPath = "transform.rotation.z"
                static let Duration: CFTimeInterval = 1.0
                static let IsRemovedOnCompletion = false
                static let RepeatCount = Float.greatestFiniteMagnitude
            }
            
        }
        
    }
    
    
}







