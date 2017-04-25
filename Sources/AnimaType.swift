//
//  Animas.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/12.
//
//

import Foundation

public enum AnimaType {
    
    case moveByX(CGFloat)
    case moveByY(CGFloat)
    case moveByXY(x: CGFloat, y: CGFloat)
    case moveTo(x: CGFloat, y: CGFloat)
    case opacity(Float)
    
    case rotateByXRadian(CGFloat)
    case rotateByXDegree(CGFloat)
    
    case rotateByYRadian(CGFloat)
    case rotateByYDegree(CGFloat)
    
    case rotateByZRadian(CGFloat)
    case rotateByZDegree(CGFloat)
    
    case scaleBy(CGFloat)
    case scaleByX(CGFloat)
    case scaleByY(CGFloat)
    
    case borderColor(UIColor)
    case borderWidth(CGFloat)
    case cornerRadius(CGFloat)
    case masksToBounds(Bool)
    case moveAnchor(AnimaAnchorPoint)
    case moveAnchorPointZ(CGFloat)
    case hidden(Bool)
    case zPosition(CGFloat)
    case shadowColor(UIColor)
    case shadowOpacity(Float)
    case shadowRadius(CGFloat)
    case shadowPath(CGPath)
    
    @available(*, deprecated, message: "\"movePath\" is deprecated for now. If you use it with \"autoreverse\" option, It will make strange animation. Can you submit a fixing PR?")
    case movePath(path: CGPath, keyTimes: [Double])
    case original(keyPath: String, from: Any?, to: Any)
    
    case backgroundColor(UIColor)
}

enum RotateType: String {
    case z = "z"
    case x = "x"
    case y = "y"
    
    var keyPath: String {
        return "transform.rotation.\(rawValue)"
    }
}

enum Scaletype {
    case `default`
    case x
    case y
    
    var keyPath: String {
        switch self {
        case .default:
            return "transform.scale"
        case .x:
            return "transform.scale.x"
        case .y:
            return "transform.scale.y"
        }
    }
}
