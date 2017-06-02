//
//  CG+Random.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 10/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Darwin

private let _wordSize = __WORDSIZE


public extension CGFloat {
    public static func random(lower: CGFloat = 0.0, upper: CGFloat = 1.0) -> CGFloat {
        switch _wordSize {
        case 32:
            let r = CGFloat(arc4random(UInt32.self)) / CGFloat(UInt32.max)
            return (r * (upper - lower)) + lower
        case 64:
            let r = CGFloat(arc4random(UInt64.self)) / CGFloat(UInt64.max)
            return (r * (upper - lower)) + lower
        default: return lower
        }
    }
}


public extension CGPoint {
    
    public static func randomWithinCGRect(rectangle: CGRect) -> CGPoint {
        let x = CGFloat.random(lower: rectangle.minX, upper: rectangle.maxX)
        let y = CGFloat.random(lower: rectangle.minY, upper: rectangle.maxY)
        
        return CGPoint(x: x, y: y)
    }
    
    
    public static func randomWithinCGSize(size: CGSize) -> CGPoint {
        let x = CGFloat.random(lower: 0.0, upper: size.width)
        let y = CGFloat.random(lower: 0.0, upper: size.height)
        
        return CGPoint(x: x, y: y)
    }
    
    
    public static func random(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) -> CGPoint {
        return CGPoint.randomWithinCGRect(rectangle: CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY))
    }
    
    
    public static func random(withinRadius radius: CGFloat, ofPoint midPoint:CGPoint) -> CGPoint {
        let r = CGFloat.random(lower: 0.0, upper: radius)
        let a = CGFloat.random(lower: 0.0, upper: CGFloat(Double.pi * 2))
        let x = midPoint.x + r * cos(a)
        let y = midPoint.y + r * sin(a)
        return CGPoint(x: x, y: y)
    }
    
}


