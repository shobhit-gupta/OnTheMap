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
        outerIndicator.rotateClockwise = true
        innerIndicator.rotateClockwise = false
    }
    
    
    private func setupIndicator(_ indicator: CustomActivityIndicatorView) {
        indicator.backgroundColor = UIColor.clear
        indicator.isOpaque = true
    }
    
    
    private func setupContainerStackView() {
        configureContainerStackView()
        let textStackView = setupTextStackView()
        let outerIndicatorStackView = outerIndicator.encompassInStackView(axis: .vertical, alignment: .center)
        [outerIndicatorStackView, textStackView].forEach { containerStackView.addArrangedSubview($0) }
        
        let innerIndicatorStackView = innerIndicator.encompassInStackView(axis: .vertical, alignment: .center)
        [containerStackView, innerIndicatorStackView].forEach { addSubview($0) }
        
        innerIndicatorStackView.autoAlignAxis(.horizontal, toSameAxisOf: outerIndicatorStackView)
        innerIndicatorStackView.autoAlignAxis(.vertical, toSameAxisOf: outerIndicatorStackView)
    }
    
    
    private func configureContainerStackView() {
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = 16.0
    }
    
    
    private func setupTextStackView() -> UIStackView {
        let textStackView = UIStackView(frame: CGRect.zero)
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.distribution = .fill
        textStackView.spacing = 8.0
        [titleLabel, subtitleLabel].forEach { textStackView.addArrangedSubview($0) }
        return textStackView
    }
    
    
    private func setupLabels() {
        setupLabel(titleLabel)
        setupLabel(subtitleLabel)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    
    
    private func setupLabel(_ label: UILabel) {
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.shadowOffset = CGSize(width: 0.0, height: -1.0)
    }
    
    
    private func setupOverlay() {
        let properties = OverlayType.Properties(color: ArtKit.primaryColor.withAlphaComponent(0.2),
                                                blur: OverlayType.Properties.Blur(style: .dark, isVibrant: false))
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





