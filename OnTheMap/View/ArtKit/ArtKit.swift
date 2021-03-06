//
//  ArtKit.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 17/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class ArtKit : NSObject {

    //// Cache

    private struct Cache {
        static let white: UIColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        static let secondaryColor: UIColor = ArtKit.white
        static let shadowOfSecondaryColor: UIColor = ArtKit.secondaryColor.shadow(withLevel: 0.3)
        static let highlightOfSecondaryColor: UIColor = ArtKit.secondaryColor.highlight(withLevel: 0.1)
        static let from101Theme: UIColor = UIColor(red: 0.459, green: 0.051, blue: 0.243, alpha: 1.000)
        static let primaryColor: UIColor = ArtKit.from101Theme
        static let shadowOfPrimaryColor: UIColor = ArtKit.primaryColor.shadow(withLevel: 0.3)
        static let highlightOfPrimaryColor: UIColor = ArtKit.primaryColor.highlight(withLevel: 0.1)
        static let backgroundColor: UIColor = ArtKit.from101Theme
        static let green1: UIColor = UIColor(red: 0.000, green: 0.741, blue: 0.612, alpha: 1.000)
        static let green2: UIColor = UIColor(red: 0.000, green: 0.631, blue: 0.525, alpha: 1.000)
        static let purple1: UIColor = UIColor(red: 0.608, green: 0.337, blue: 0.718, alpha: 1.000)
        static let purple2: UIColor = UIColor(red: 0.557, green: 0.247, blue: 0.686, alpha: 1.000)
        static let blue1: UIColor = UIColor(red: 0.180, green: 0.592, blue: 0.871, alpha: 1.000)
        static let blue3: UIColor = UIColor(red: 0.173, green: 0.243, blue: 0.318, alpha: 1.000)
        static let blue4: UIColor = UIColor(red: 0.200, green: 0.286, blue: 0.373, alpha: 1.000)
        static let orange1: UIColor = UIColor(red: 0.961, green: 0.616, blue: 0.000, alpha: 1.000)
        static let orange2: UIColor = UIColor(red: 0.910, green: 0.498, blue: 0.016, alpha: 1.000)
        static let grey6: UIColor = UIColor(red: 0.424, green: 0.424, blue: 0.424, alpha: 1.000)
        static let grey7: UIColor = UIColor(red: 0.314, green: 0.314, blue: 0.314, alpha: 1.000)
        static let grey8: UIColor = UIColor(red: 0.180, green: 0.180, blue: 0.180, alpha: 1.000)
    }

    //// Colors

    public dynamic class var white: UIColor { return Cache.white }
    public dynamic class var secondaryColor: UIColor { return Cache.secondaryColor }
    public dynamic class var shadowOfSecondaryColor: UIColor { return Cache.shadowOfSecondaryColor }
    public dynamic class var highlightOfSecondaryColor: UIColor { return Cache.highlightOfSecondaryColor }
    public dynamic class var from101Theme: UIColor { return Cache.from101Theme }
    public dynamic class var primaryColor: UIColor { return Cache.primaryColor }
    public dynamic class var shadowOfPrimaryColor: UIColor { return Cache.shadowOfPrimaryColor }
    public dynamic class var highlightOfPrimaryColor: UIColor { return Cache.highlightOfPrimaryColor }
    public dynamic class var backgroundColor: UIColor { return Cache.backgroundColor }
    public dynamic class var green1: UIColor { return Cache.green1 }
    public dynamic class var green2: UIColor { return Cache.green2 }
    public dynamic class var purple1: UIColor { return Cache.purple1 }
    public dynamic class var purple2: UIColor { return Cache.purple2 }
    public dynamic class var blue1: UIColor { return Cache.blue1 }
    public dynamic class var blue3: UIColor { return Cache.blue3 }
    public dynamic class var blue4: UIColor { return Cache.blue4 }
    public dynamic class var orange1: UIColor { return Cache.orange1 }
    public dynamic class var orange2: UIColor { return Cache.orange2 }
    public dynamic class var grey6: UIColor { return Cache.grey6 }
    public dynamic class var grey7: UIColor { return Cache.grey7 }
    public dynamic class var grey8: UIColor { return Cache.grey8 }

    //// Drawing Methods

    public dynamic class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 240, height: 120), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 240, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 240, y: resizedFrame.height / 120)
        
        context.restoreGState()

    }




    @objc(ArtKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}



private extension UIColor {
    func withHue(_ newHue: CGFloat) -> UIColor {
        var saturation: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: newHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    func withSaturation(_ newSaturation: CGFloat) -> UIColor {
        var hue: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
    }
    func withBrightness(_ newBrightness: CGFloat) -> UIColor {
        var hue: CGFloat = 1, saturation: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    func withAlpha(_ newAlpha: CGFloat) -> UIColor {
        var hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: newAlpha)
    }
    func highlight(withLevel highlight: CGFloat) -> UIColor {
        var red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red * (1-highlight) + highlight, green: green * (1-highlight) + highlight, blue: blue * (1-highlight) + highlight, alpha: alpha * (1-highlight) + highlight)
    }
    func shadow(withLevel shadow: CGFloat) -> UIColor {
        var red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red * (1-shadow), green: green * (1-shadow), blue: blue * (1-shadow), alpha: alpha * (1-shadow) + shadow)
    }
}
