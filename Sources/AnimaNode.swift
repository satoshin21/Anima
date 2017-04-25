//
//  AnimaNode.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/12.
//
//

import Foundation

internal enum NodeType {
    case single(AnimaType)
    case group([AnimaType])
    case wait(TimeInterval)
    case anchor(AnimaAnchorPoint)
}

internal struct AnimaNode {
    
    let nodeType: NodeType
    
    let options: [AnimaOption]
    
    init(nodeType: NodeType, options: [AnimaOption] = []) {
        self.nodeType = nodeType
        self.options = options
    }
    
    func addAnimation(to layer: CALayer, animationDidStop: @escaping AnimationDidStop) {
        
        switch nodeType {
        case .single(let animationType):
            
            if let animation = instantiateAnimaAnimation(animationType, layer: layer, animationDidStop: animationDidStop) {
                
                layer.add(animation, forKey: "\(Date.timeIntervalSinceReferenceDate)")
            }
        case .group(let animations):
            
            let animations = animations.flatMap({ (animaType) -> CAAnimation? in
                let animation = instantiateAnimaAnimation(animaType, layer: layer, animationDidStop: {_ in })
                animation?.delegate = nil
                return animation
            })
            
            let group = AnimaAnimationGroup(options: options)
            group.didStop = { (finished) in
                animationDidStop(true)
            }
            
            if let groupDuration = options.first(where: {$0 == .duration(.nan)}), case let .duration(duration) = groupDuration {
                
                animations.forEach({$0.duration = duration})
                group.duration = duration
            } else if let duration = animations.max(by: { $0.0.duration > $0.1.duration } )?.duration {
                
                group.duration = duration
            }
            
            group.animations = animations
            layer.add(group, forKey: nil)
            
        case .anchor(let anchorPoint):
            
            layer.position += layer.diffPoint(for: anchorPoint)
            layer.anchorPoint = anchorPoint.anchorPoint
            
            animationDidStop(true)
            
        case .wait(let timeInterval):
            
            let deadline: DispatchTime = .now() + timeInterval
            DispatchQueue(label: "jp.hatenadiary.satoshin21.AnimaNode").asyncAfter(deadline: deadline, execute: {
                
                DispatchQueue.main.async {
                    
                    animationDidStop(true)
                }
            })
        }
    }
    
    func instantiateAnimaAnimation(_ animationType: AnimaType, layer: CALayer, animationDidStop: @escaping AnimationDidStop) -> CAAnimation? {
         
        switch animationType {
        case .moveByX(let x):
            
            return createTranslationAnimation(move: CGPoint(x: x, y: 0), layer: layer, animationDidStop: animationDidStop)
            
        case .moveByY(let y):
            return createTranslationAnimation(move: CGPoint(x: 0, y: y), layer: layer, animationDidStop: animationDidStop)
            
        case .moveByXY(let x, let y):
           return createTranslationAnimation(move: CGPoint(x: x, y: y), layer: layer, animationDidStop: animationDidStop)

        case .moveTo(let x, let y):
            
            let target = CGPoint(x: x, y: y)
            let diffPoint = target - layer.position

            let currentX: CGFloat = layer.currentValue(keyPath: "transform.translation.x")
            let currentY: CGFloat = layer.currentValue(keyPath: "transform.translation.y")
            let currentTranslation = CGPoint(x: currentX, y: currentY)
            let lastPoint = diffPoint - currentTranslation
            return createTranslationAnimation(move: lastPoint, layer: layer, animationDidStop: animationDidStop)
            
        case .scaleByX(let x):
            
            return createScaleAnimation(scale: x, layer: layer, animationDidStop: animationDidStop, scaleType: .x)
        case .scaleByY(let y):
            
            return createScaleAnimation(scale: y, layer: layer, animationDidStop: animationDidStop, scaleType: .y)
        case .scaleBy(let scale):
            
            return createScaleAnimation(scale: scale, layer: layer, animationDidStop: animationDidStop, scaleType: .default)
        case .moveAnchor(let anchorPoint):
            
            return createAnimation(keyPath: #keyPath(CALayer.anchorPoint),
                                   from: layer.anchorPoint,
                                   to: anchorPoint.anchorPoint,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .backgroundColor(let color):
            
            return createAnimation(keyPath: #keyPath(CALayer.backgroundColor),
                                   from: layer.backgroundColor,
                                   to: color.cgColor,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .rotateByXRadian(let radian):
            
            return createRotateAnimation(radian: radian, layer: layer, animationDidStop: animationDidStop, rotateType: .x)
        case .rotateByXDegree(let degree):
            
            return createRotateAnimation(radian: degree.degreesToRadians, layer: layer, animationDidStop: animationDidStop, rotateType: .x)
            
        case .rotateByYRadian(let radian):
            
            return createRotateAnimation(radian: radian, layer: layer, animationDidStop: animationDidStop, rotateType: .y)
        case .rotateByYDegree(let degree):
            
            return createRotateAnimation(radian: degree.degreesToRadians, layer: layer, animationDidStop: animationDidStop, rotateType: .y)
            
        case .rotateByZRadian(let radian):
            
            return createRotateAnimation(radian: radian, layer: layer, animationDidStop: animationDidStop, rotateType: .z)
        case .rotateByZDegree(let degree):
            
            return createRotateAnimation(radian: degree.degreesToRadians, layer: layer, animationDidStop: animationDidStop, rotateType: .z)
            
        case .opacity(let opacity):
            
            return createAnimation(keyPath: #keyPath(CALayer.opacity),
                                   from: layer.opacity,
                                   to: opacity,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .borderColor(let color):
            
            return createAnimation(keyPath: #keyPath(CALayer.borderColor),
                                   from: layer.borderColor,
                                   to: color.cgColor,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .borderWidth(let width):
            
            return createAnimation(keyPath: #keyPath(CALayer.borderWidth),
                                   from: layer.borderWidth,
                                   to: width,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .cornerRadius(let cornerRadius):
            
            return createAnimation(keyPath: #keyPath(CALayer.cornerRadius),
                                   from: layer.cornerRadius,
                                   to: cornerRadius,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
        case .masksToBounds(let masksToBounds):
            
            return createAnimation(keyPath: #keyPath(CALayer.masksToBounds),
                                   from: layer.masksToBounds,
                                   to: masksToBounds,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
        case .moveAnchorPointZ(let anchorPointZ):
            
            return createAnimation(keyPath: #keyPath(CALayer.anchorPointZ),
                                   from: layer.anchorPointZ,
                                   to: anchorPointZ,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .hidden(let isHidden):
            
            return createAnimation(keyPath: #keyPath(CALayer.isHidden),
                                   from: layer.isHidden,
                                   to: isHidden,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .zPosition(let zPosition):
            
            return createAnimation(keyPath: #keyPath(CALayer.zPosition),
                                   from: layer.zPosition,
                                   to: zPosition,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .shadowColor(let shadowColor):
            
            return createAnimation(keyPath: #keyPath(CALayer.shadowColor),
                                   from: layer.shadowColor,
                                   to: shadowColor.cgColor,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .shadowOpacity(let shadowOpacity):
            
            return createAnimation(keyPath: #keyPath(CALayer.shadowOpacity),
                                   from: layer.shadowOpacity,
                                   to: shadowOpacity,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .shadowRadius(let shadowRadius):
            
            return createAnimation(keyPath: #keyPath(CALayer.shadowRadius),
                                   from: layer.shadowRadius,
                                   to: shadowRadius,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .shadowPath(let shadowPath):
            
            return createAnimation(keyPath: #keyPath(CALayer.shadowPath),
                                   from: layer.shadowPath,
                                   to: shadowPath,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .original(let keyPath, let from, let to):
            
            return createAnimation(keyPath: keyPath,
                                   from: from,
                                   to: to,
                                   layer: layer,
                                   animationDidStop: animationDidStop)
            
        case .movePath(let path, let keyTimes):
            
            let futurePosition: CGPoint = {
                if options.contains(.autoreverse) {
                    
                    return path.firstPoint ?? layer.position
                    
                } else {
                    return path.currentPoint
                }
            }()
            
            let animation = AnimaKeyframeAnimation(keyPath: #keyPath(CALayer.position), options: options)
            animation.didStop = animationDidStop
            animation.keyTimes = keyTimes.map({NSNumber(value: $0)})
            animation.path = path
            layer.position = futurePosition
            
            return animation
            
        }
    }
    
    func createTranslationAnimation(move: CGPoint, layer: CALayer, animationDidStop: @escaping AnimationDidStop) -> CAAnimation? {
       
        let keyPath = "transform.translation"
        let currentTranslation: CGPoint = {
            if let current = layer.value(forKeyPath: keyPath) as? CGSize {
                return CGPoint(x: current.width, y: current.height)
            } else {
                layer.setValue(CGPoint.zero, forKeyPath: keyPath)
                return .zero
            }
        }()
        let to = move + currentTranslation
        return createAnimation(keyPath: keyPath, from: currentTranslation, to: to, layer: layer, animationDidStop: animationDidStop)
    }
    
    func createMoveAnimation(position: CGPoint, layer: CALayer, animationDidStop: @escaping AnimationDidStop) -> CAAnimation? {
        
        return createAnimation(keyPath: #keyPath(CALayer.position),
                               from: layer.position,
                               to: position,
                               layer: layer,
                               animationDidStop: animationDidStop)
    }
    
    func createRotateAnimation(radian: CGFloat, layer: CALayer, animationDidStop: @escaping AnimationDidStop, rotateType: RotateType) -> CAAnimation? {
        
        let currentRotate: CGFloat = {
            if let current = layer.value(forKeyPath: rotateType.keyPath) as? CGFloat {
                return current
            } else {
                layer.setValue(CGFloat(0), forKeyPath: rotateType.keyPath)
                return 0
            }
        }()
        let toValue = currentRotate + radian
        return createAnimation(keyPath: rotateType.keyPath,
                               from: currentRotate,
                               to: toValue,
                               layer: layer,
                               animationDidStop: animationDidStop)
    }
    
    func createScaleAnimation(scale: CGFloat, layer: CALayer, animationDidStop: @escaping AnimationDidStop, scaleType: Scaletype) -> CAAnimation? {
        
        let currentScale: CGFloat = {
            if let current = layer.value(forKeyPath: scaleType.keyPath) as? CGFloat {
                return current
            } else {
                layer.setValue(CGFloat(1), forKeyPath: scaleType.keyPath)
                return 1
            }
        }()
        let toValue = currentScale + scale
        return createAnimation(keyPath: scaleType.keyPath,
                               from: currentScale,
                               to: toValue,
                               layer: layer,
                               animationDidStop: animationDidStop)
    }
    
    func createAnimation<T>(keyPath: String, from: T?, to: T, layer: CALayer, animationDidStop: @escaping AnimationDidStop) -> CAAnimation {
        
        let defaultAnimation = DefaultAnimation(keyPath: keyPath, animationValue: to, options: options)
        let futureProperty = defaultAnimation.futureProperty(currentProperty: from)
        let anim = defaultAnimation.instantiateAnimation(currentProperty: from, didStop: animationDidStop)
        layer.setValue(futureProperty, forKeyPath: keyPath)
        return anim
    }
}
