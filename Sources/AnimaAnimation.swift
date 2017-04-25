//
//  AnimaAnimationProtocol.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/16.
//
//

import UIKit

private var CompletionOptionKey: UInt = 0
private var DidStopKey: UInt = 0

protocol AnimaAnimation: CAAnimationDelegate {
    var completionOption: (() -> Void)?  { get set }
    
    var didStart: AnimationDidStart? { get set }
    var didStop: AnimationDidStop? { get set }
    
    func setBasicAnimationValues<T>(fromValue: T?, toValue: T)
}

extension AnimaAnimation where Self: AnimaSpringAnimation {
    
    func setBasicAnimationValues<T>(fromValue: T?, toValue: T) {
        
        self.fromValue  = fromValue
        self.toValue    = toValue
    }
}

extension AnimaAnimation where Self: AnimaKeyframeAnimation {
    
    func setBasicAnimationValues<T>(fromValue: T?, toValue: T) {
        values = [fromValue ?? toValue,  toValue]
        keyTimes = [0.0, 1.0].map({NSNumber(value: $0)})
    }
}

extension AnimaAnimation where Self: CAAnimation {
    
    func set(options: [AnimaOption]) {

        for option in options {
            switch option {
            case .duration(let timeInterval):
                duration = CFTimeInterval(timeInterval)
            case .timingFunction(let timingFunction):
                self.timingFunction = timingFunction.timingFunction
            case .autoreverse:
                self.autoreverses = true
            case .repeat(let count):
                self.repeatCount = count
            case .completion(let completion):
                self.completionOption = completion
            }
        }
        
        // NOTE: AnimaOption does not compare associated value.
        if !options.contains(.duration(.nan)) {
            
            duration = CFTimeInterval(Anima.defaultDuration)
        }
        
        // In this case, ".linear" is unrealated value.
        if !options.contains(.timingFunction(.linear)) {
            
            timingFunction = Anima.defaultTimingFunction.timingFunction
        }
    }
    
    func set(didStart: AnimationDidStart? = nil, didStop: AnimationDidStop? = nil) {
        
        self.didStart = didStart
        self.didStop = didStop
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        
        didStart?()
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didStop?(flag)
        completionOption?()
    }
}
