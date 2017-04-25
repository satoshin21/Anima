//
//  AnimaUtility.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/14.
//
//

import Foundation

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func +=( left: inout CGPoint, right: CGPoint) {
    
    left = left + right
}

func -=( left: inout CGPoint, right: CGPoint) {
    
    left = left - right
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension CGPath {
    
    var firstPoint: CGPoint? {
        var firstPoint: CGPoint? = nil
        forEach { (element) in
            guard firstPoint == nil else {
                return
            }
            if element.type == .moveToPoint {
                firstPoint = element.points.pointee
            }
        }
        return firstPoint
    }
    
    func forEach( body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: callback)
    }
}
