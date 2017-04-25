//
//  AnimaAnchorPoint.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/22.
//
//

public enum AnimaAnchorPoint {
    case center
    case left
    case right
    case bottom
    case top
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case original(CGPoint)
    
    public var anchorPoint: CGPoint {
        
        switch self {
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .left:
            return CGPoint(x: 0.0, y: 0.5)
        case .right:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottom:
            return CGPoint(x: 0.5, y: 1.0)
        case .top:
            return CGPoint(x: 0.5, y: 0.0)
        case .topLeft:
            return CGPoint(x: 0.0, y: 0.0)
        case .topRight:
            return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft:
            return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight:
            return CGPoint(x: 1.0, y: 1.0)
        case .original(let point):
            return point
        }
    }
}
