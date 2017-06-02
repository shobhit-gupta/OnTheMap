//
//  BusyView.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 20/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit
import PureLayout


@IBDesignable
open class BusyView: OverlayView {
    
    // MARK: IBInspectables
    @IBInspectable public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    @IBInspectable public var subtitle: String? {
        get { return subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }
    
    @IBInspectable public var outerIndicatorImage: UIImage? {
        get { return outerIndicator.image }
        set { outerIndicator.image = newValue }
    }
    
    @IBInspectable public var innerIndicatorImage: UIImage? {
        get { return innerIndicator.image }
        set { innerIndicator.image = newValue }
    }
    
    
    // MARK: Private variables and types
    fileprivate let titleLabel = UILabel(frame: CGRect.zero)
    fileprivate let subtitleLabel = UILabel(frame: CGRect.zero)
    fileprivate let outerIndicator = CustomActivityIndicatorView(frame: CGRect.zero)
    fileprivate let innerIndicator = CustomActivityIndicatorView(frame: CGRect.zero)
    fileprivate let containerStackView = UIStackView(frame: CGRect.zero)
    
    private var shouldSetupConstraints = true
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    
    // MARK: UIView Methods
    override open func updateConstraints() {
        if shouldSetupConstraints {
            containerStackView.autoPinEdge(.left, to: .left, of: self)
            containerStackView.autoPinEdge(.right, to: .right, of: self)
            containerStackView.autoAlignAxis(.horizontal, toSameAxisOf: self)
        }
        super.updateConstraints()
        shouldSetupConstraints = false
    }
    
}


//******************************************************************************
//                              MARK: Setup
//******************************************************************************
fileprivate extension BusyView {

    fileprivate func setupView() {
        setupOverlay()
        setupLabels()
        setupIndicators()
        setupContainerStackView()
    }
    
    
    private func setupIndicators() {
        setupIndicator(outerIndicator)
        setupIndicator(innerIndicator)
        outerIndicator.rotateClockwise = Default.BusyView.Indicator.Outer.RotateClockWise
        innerIndicator.rotateClockwise = Default.BusyView.Indicator.Inner.RotateClockWise
    }
    
    
    private func setupIndicator(_ indicator: CustomActivityIndicatorView) {
        indicator.backgroundColor = Default.BusyView.Indicator.BackgroundColor
        indicator.isOpaque = Default.BusyView.Indicator.IsOpaque
    }
    
    
    private func setupContainerStackView() {
        configureContainerStackView()
        let textStackView = setupTextStackView()
        let outerIndicatorStackView = outerIndicator.encompassInStackView(axis: Default.BusyView.StackView.Indicator.Outer.Axis,
                                                                          alignment: Default.BusyView.StackView.Indicator.Outer.Alignment)
        [outerIndicatorStackView, textStackView].forEach { containerStackView.addArrangedSubview($0) }
        
        let innerIndicatorStackView = innerIndicator.encompassInStackView(axis: Default.BusyView.StackView.Indicator.Inner.Axis,
                                                                          alignment: Default.BusyView.StackView.Indicator.Inner.Alignment)
        [containerStackView, innerIndicatorStackView].forEach { addSubview($0) }
        
        innerIndicatorStackView.autoAlignAxis(.horizontal, toSameAxisOf: outerIndicatorStackView)
        innerIndicatorStackView.autoAlignAxis(.vertical, toSameAxisOf: outerIndicatorStackView)
    }
    
    
    private func configureContainerStackView() {
        containerStackView.axis = Default.BusyView.StackView.Container.Axis
        containerStackView.alignment = Default.BusyView.StackView.Container.Alignment
        containerStackView.distribution = Default.BusyView.StackView.Container.Distribution
        containerStackView.spacing = Default.BusyView.StackView.Container.Spacing
    }
    
    
    private func setupTextStackView() -> UIStackView {
        let textStackView = UIStackView(frame: CGRect.zero)
        textStackView.axis = Default.BusyView.StackView.Text.Axis
        textStackView.alignment = Default.BusyView.StackView.Text.Alignment
        textStackView.distribution = Default.BusyView.StackView.Text.Distribution
        textStackView.spacing = Default.BusyView.StackView.Text.Spacing
        [titleLabel, subtitleLabel].forEach { textStackView.addArrangedSubview($0) }
        return textStackView
    }
    
    
    private func setupLabels() {
        setupLabel(titleLabel)
        setupLabel(subtitleLabel)
        titleLabel.font = Default.BusyView.Label.Title.Font
        subtitleLabel.font = Default.BusyView.Label.Subtitle.Font
    }
    
    
    private func setupLabel(_ label: UILabel) {
        label.textColor = Default.BusyView.Label.Text.Color
        label.textAlignment = Default.BusyView.Label.Text.Alignment
        label.numberOfLines = Default.BusyView.Label.NumberOfLines
        label.shadowOffset = Default.BusyView.Label.ShadowOffset
    }
    
    
    private func setupOverlay() {
        let properties = OverlayType.Properties(color: Default.BusyView.Overlay.BackgroundColor,
                                                blur: OverlayType.Properties.Blur(style: Default.BusyView.Overlay.BlurEffectStyle,
                                                                                  isVibrant: false))
        _ = setupOverlay(withDesired: properties)
        
    }
    
}


public extension BusyView {
    
    public func startAnimation() {
        [outerIndicator, innerIndicator].forEach { $0.startAnimation() }
    }
    
    
    public func stopAnimation() {
        [outerIndicator, innerIndicator].forEach { $0.stopAnimation() }
    }
    
    
    public func present() {
        startAnimation()
        isHidden = false
    }
    
    
    public func dismiss() {
        if !isHidden {
            stopAnimation()
            isHidden = true
        }
    }
    
}


public extension BusyView {
    
    public static func overlay(on view: UIView,
                               withTitle title: String?,
                               subtitle: String?,
                               outerIndicatorImage: UIImage?,
                               innerIndicatorImage: UIImage?) -> BusyView {
        
        let busyView = BusyView(frame: CGRect.zero)
        
        busyView.title = title
        busyView.subtitle = subtitle
        busyView.outerIndicatorImage = outerIndicatorImage
        busyView.innerIndicatorImage = innerIndicatorImage
        
        view.addSubview(busyView)
        busyView.autoPinEdgesToSuperviewEdges()
        
        busyView.isHidden = true
        
        return busyView
    }
    
}


public extension Default {
    
    enum BusyView {
        
        enum Indicator {
            
            static let BackgroundColor = UIColor.clear
            static let IsOpaque = true
            
            enum Outer {
                static let RotateClockWise = true
            }
            
            enum Inner {
                static let RotateClockWise = false
            }
        }
        
        
        enum Label {
            
            static let NumberOfLines = 0
            static let ShadowOffset = CGSize(width: 0.0, height: -1.0)
            
            enum Text {
                static let Color: UIColor = ArtKit.secondaryColor // UIColor.white
                static let Alignment: NSTextAlignment = .center
            }
            
            enum Title {
                static let Font = UIFont.preferredFont(forTextStyle: .headline)
            }
            
            enum Subtitle {
                static let Font = UIFont.preferredFont(forTextStyle: .subheadline)
            }
        }
    
        
        enum StackView {
            
            enum Container {
                static let Axis: UILayoutConstraintAxis = .vertical
                static let Alignment: UIStackViewAlignment = .fill
                static let Distribution: UIStackViewDistribution = .fill
                static let Spacing: CGFloat = 16.0
            }
            
            
            enum Text {
                static let Axis: UILayoutConstraintAxis = .vertical
                static let Alignment: UIStackViewAlignment = .fill
                static let Distribution: UIStackViewDistribution = .fill
                static let Spacing: CGFloat = 8.0
            }
            
            
            enum Indicator {
                
                enum Outer {
                    static let Axis: UILayoutConstraintAxis = .vertical
                    static let Alignment: UIStackViewAlignment = .center
                }
                
                enum Inner {
                    static let Axis: UILayoutConstraintAxis = .vertical
                    static let Alignment: UIStackViewAlignment = .center
                }
                
            }
            
        }
        
        
        enum Overlay {
            static let BlurEffectStyle: UIBlurEffectStyle = Default.Overlay.BlurEffectStyle
            static let BackgroundColor = ArtKit.primaryColor.withAlphaComponent(0.2) // Default.Overlay.BackgroundColor
        }
        
    }
    
    
}



