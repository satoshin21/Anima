//
//  File.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/12.
//
//

import Foundation

protocol AnimationType {
    
    associatedtype KeyPathType
    
    var animationValue: KeyPathType { get }
    
    var options: [AnimaOption] { get }
    
    func futureProperty(currentProperty: KeyPathType?) -> KeyPathType?
    
    func instantiateAnimation(currentProperty: KeyPathType?, didStop: @escaping AnimationDidStop) -> CAAnimation
}

extension AnimationType {
    
    fileprivate func instantiateAnimation(keyPath: String, currentProperty: KeyPathType?, didStop: @escaping AnimationDidStop) -> CAAnimation {
        
        var springInfo: SpringInfo?
        options.forEach { (option) in
            if case .timingFunction(let timingFunction) = option, let info = timingFunction.springInfo {
                springInfo = info
            }
        }
        
        if springInfo == nil {
            
            if let info = Anima.defaultTimingFunction.springInfo {
                springInfo = info
            }
        }
        
        if let springInfo = springInfo {
            
            let animation = AnimaSpringAnimation(keyPath: keyPath, options: options, springInfo: springInfo)
            animation.didStop = didStop
            animation.setBasicAnimationValues(fromValue: currentProperty, toValue: animationValue)
            return animation
        } else {
            
            let animation = AnimaBasicAnimation(keyPath: keyPath, options: options)
            animation.didStop = didStop
            animation.setBasicAnimationValues(fromValue: currentProperty, toValue: animationValue)
            return animation
        }
    }
    
    func futureProperty(currentProperty: KeyPathType?) -> KeyPathType? {
        if options.contains(.autoreverse) {
            return currentProperty
        } else {
            return animationValue
        }
    }
}

struct DefaultAnimation<T>: AnimationType {
    
    typealias KeyPathType = T
    
    var keyPath: String
    
    var animationValue: T
    
    var options: [AnimaOption]
    
    func instantiateAnimation(currentProperty: T?, didStop: @escaping AnimationDidStop) -> CAAnimation {
        
        return instantiateAnimation(keyPath: keyPath, currentProperty: currentProperty, didStop: didStop)
    }
}
