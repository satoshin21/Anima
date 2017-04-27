//
//  Anima.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/09.
//
//

import UIKit

public typealias AnimaCompletion = () -> Void

public class Anima: NSObject {

    public enum Status: Equatable {
        case notFired
        case active
        case willPaused
        case paused(AnimaCompletion?)
        case completed
        
        public static func ==(left: Status, right: Status) -> Bool {
            switch (left, right) {
            case (.notFired, .notFired):
                fallthrough
            case (.active, .active):
                fallthrough
            case (.willPaused, .willPaused):
                fallthrough
            case (.paused, .paused):
                fallthrough
            case (.completed, .completed):
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Properties
    
    public private(set) var status: Status = .notFired
    
    /** 
     If you don't add any duration option 'AnimaOption.duration()',
     `defaultDuration` is applied. Default value is one.
     */
    public static var defaultDuration: TimeInterval = 1
    
    /**
     If you don't add any TimingFunction option 'AnimaOption.timingFunction()',
     `defaultTimingFunction` is applied. Default value is 'easeInCubic'.
     */
    public static var defaultTimingFunction = TimingFunction.easeInCubic
    
    /// animation stack.
    internal var stack = [AnimaNode]()
   
    /// Animation target Layer.
    weak private var layer: CALayer?
    
    public var isActive: Bool {
        return status == .active
    }
    
    // MARK: - Initializer
    
    /// Anima needs target layer of animation in initializer.
    init(_ layer: CALayer) {
        self.layer = layer
        super.init()
    }
    
    // MARK: - Set Animations
    
    /// call this method to define next (or first) animation.
    ///
    /// - Parameters:
    ///   - animationType: Animation that you want to perform (moveX, size, rotation, ... etc)
    ///   - options: Animation option that you want to apply (duration, timingFunction, completion, ... etc)
    /// - Returns: itself (Anima object)
    public func then(_ animationType: AnimaType, options: [AnimaOption] = []) -> Self {
        
        return next(animaNode: AnimaNode(nodeType: .single(animationType), options: options))
    }
    
    /// call this method to define next (or first) grouped animation.
    /// each animations will run concurrently in the same time.
    ///
    /// - Parameters:
    ///   - animationType: Animation that you want to perform (moveX, size, rotation, ... etc)
    ///   - options: Animation option that you want to apply (duration, timingFunction, completion, ... etc)
    /// - Returns: itself (Anima object)
    public func then(group animations: [AnimaType], options: [AnimaOption] = []) -> Self {
        
        return next(animaNode: AnimaNode(nodeType: .group(animations), options: options))
    }
    
    
    /// call this method to delay next animation.
    ///
    /// - Parameter t: TimeInterval. time of waiting next action
    /// - Returns: itself
    public func then(waitFor t: TimeInterval) -> Self {
        
        return next(animaNode: AnimaNode(nodeType: .wait(t)))
    }
    
    /// Set the CALayer.anchorPoint value with enum of "AnchorPoint".
    /// Usualy, updating CALayer.anchorPoint directly, it will change layer's frame.
    /// but this method do not affect layer's frame, it update layer's anchorPoint only.
    /// - Parameter anchorPoint: AnchorPoint
    /// - Returns: itself
    public func then(setAnchor anchorPoint: AnimaAnchorPoint) -> Self {
        
        return next(animaNode: AnimaNode(nodeType: .anchor(anchorPoint)))
    }
    
    /// perform series of animation you defined.
    ///
    /// - Parameter completion: all of animation is finished, it will be called.
    public func fire(completion: AnimaCompletion? = nil) {
        status = .active
        
        guard stack.count > 0 else {
            onCompletion(completion)
            return
        }
        
        fireNext(completion)
    }
    
    public func pause() {
        switch status {
        case .willPaused, .active:
            status = .willPaused
        default:
            break;
        }
    }
    
    public func resume() {
        switch status {
        case .willPaused:
            status = .active
        case .paused(let completion):
            status = .active
            fireNext(completion)
        default:
            break;
        }
    }
    
    /// perform animation at top of stack.
    private func fireNext(_ completion: AnimaCompletion?) {
        
        guard case .active = status else {
            status = .paused(completion)
            return
        }
        
        guard let layer = layer, !stack.isEmpty else {
            onCompletion(completion)
            return
        }
        
        stack.removeFirst().addAnimation(to: layer) {[weak self] (finished) in
            
            self?.fireNext(completion)
        }
    }
    
    private func next(animaNode: AnimaNode) -> Self {
        
        stack.append(animaNode)
        return self
    }
    
    private func onCompletion(_ completion: AnimaCompletion?) {
        
        status = .completed
        completion?()
    }
    
    
    
}
