//
//  Anima+CALayer.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/11.
//
//

import Foundation

private var AnimaPropertyKey: UInt8 = 0
private var AnimationRectPropertyKey: UInt8 = 0

extension CALayer {
    
    public var anima: Anima {
        let anima = Anima(self)
        animas.append(anima)
        return anima
    }
    
    private var animas: [Anima] {
        get {
            guard let animas = objc_getAssociatedObject(self, &AnimaPropertyKey) as? [Anima] else {
                
                return []
            }
            return animas
        }
        set {
            objc_setAssociatedObject(self, &AnimaPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// animationBounds will set when anima perform bounds animation.
    /// please see Anima's Key-value observer methods.
    public var animationBounds: CGRect? {
        get {
            guard let animationSize = objc_getAssociatedObject(self, &AnimationRectPropertyKey) as? CGRect else {
                
                return nil
            }
            return animationSize
        }
        set {
            objc_setAssociatedObject(self, &AnimationRectPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    /// return new CALayer.position value accroding to new anchor argument.
    public func diffPoint(for anchor: AnimaAnchorPoint) -> CGPoint {
        
        let anchorDiff = anchor.anchorPoint - self.anchorPoint
        return CGPoint(x: bounds.width * anchorDiff.x, y: bounds.height * anchorDiff.y)
    }
    
    /// return new CALayer.position value accroding to new raw anchor argument.
    public func diffPoint(for anchor: CGPoint) -> CGPoint {
        
        let anchorDiff = anchor - self.anchorPoint
        return CGPoint(x: bounds.width * anchorDiff.x, y: bounds.height * anchorDiff.y)
    }
    
    internal func currentValue<T: DefaultValuable>(keyPath: String) -> T {
        return value(forKeyPath: keyPath) as? T ?? T.defaultValue
    }
}

protocol DefaultValuable {
    static var defaultValue: Self { get }
}

extension CGFloat: DefaultValuable {
    internal static var defaultValue: CGFloat {
        return 0
    }
}

extension CGSize: DefaultValuable {
    internal static var defaultValue: CGSize {
        return .zero
    }
}

extension CGPoint: DefaultValuable {
    internal static var defaultValue: CGPoint {
        return .zero
    }
    
    func diffPoint() {
        
    }
}
