//
//  CALayer+Anima.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/11.
//
//

import UIKit

internal typealias AnimationDidStart = () -> Void
internal typealias AnimationDidStop = (_ finished: Bool) -> Void

// KeyframeAnimation object used by Anima
class AnimaBasicAnimation: CABasicAnimation, AnimaAnimation {
    
    var completionOption: (() -> Void)?
    var didStop: AnimationDidStop?
    var didStart: AnimationDidStart?
    
    override init() {
        super.init()
        
    }
    
    convenience init(keyPath: String, options: [AnimaOption]) {
        self.init()
        
        self.delegate = self
        self.keyPath = keyPath
        set(options: options)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        
        didStart?()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didStop?(flag)
        completionOption?()
        delegate = nil
    }
    
    func setBasicAnimationValues<T>(fromValue: T?, toValue: T) {
        self.fromValue = fromValue
        self.toValue = toValue
    }
    
    
}

// KeyframeAnimation object used by Anima
class AnimaKeyframeAnimation: CAKeyframeAnimation, AnimaAnimation {
    
    var completionOption: (() -> Void)?
    var didStop: AnimationDidStop?
    var didStart: AnimationDidStart?
    
    override init() {
        super.init()
        
    }
    
    convenience init(keyPath: String, options: [AnimaOption]) {
        self.init()
        
        self.delegate = self
        self.keyPath = keyPath
        set(options: options)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        
        didStart?()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didStop?(flag)
        completionOption?()
        delegate = nil
    }
}

// AnimationGroup object used by Anima
internal class AnimaAnimationGroup: CAAnimationGroup, AnimaAnimation {

    var completionOption: (() -> Void)?
    var didStop: AnimationDidStop?
    var didStart: AnimationDidStart?

    override init() {
        super.init()
    }
    
    public convenience init(options: [AnimaOption]) {
        self.init()
        
        self.delegate = self
        set(options: options)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        
        didStart?()
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didStop?(flag)
        completionOption?()
        delegate = nil
    }
    
    func setBasicAnimationValues<T>(fromValue: T?, toValue: T) {
        // nothing to do...
    }
}

// SpringAnimation object used by Anima
class AnimaSpringAnimation: CASpringAnimation, AnimaAnimation {
    
    var completionOption: (() -> Void)?
    var didStop: AnimationDidStop?
    var didStart: AnimationDidStart?
    
    public var springInfo: SpringInfo?
    
    public override init() {
        
        super.init()
    }
    
    public convenience init(keyPath: String, options: [AnimaOption], springInfo: SpringInfo) {
        self.init()
        
        self.delegate = self
        self.keyPath = keyPath
        set(options: options)
        
        self.mass = springInfo.mass
        self.initialVelocity = springInfo.initialVelocity
        self.damping = springInfo.damping
        self.stiffness = springInfo.stiffness
        duration = settlingDuration
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func animationDidStart(_ anim: CAAnimation) {
        
        didStart?()
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didStop?(flag)
        completionOption?()
        delegate = nil
    }
}
