//
//  AnimaOption.swift
//  Pods
//
//  Created by Satoshi Nagasaka on 2017/03/13.
//
//

import Foundation

public enum AnimaOption: Equatable {

    case duration(TimeInterval)
    case timingFunction(TimingFunction)
    case `repeat`(count: Float)
    case autoreverse
    case completion(() -> Void)

    // MARK: - Equatable
    
    // NOTE: AnimaOption does not compare associated values.
    // so if compare ".timingFunction(.linear)" and ".timingFunction(.easeIn)", it will be true.
    public static func ==(lhs: AnimaOption, rhs: AnimaOption) -> Bool {
        
        switch (lhs, rhs) {
        case (.duration, .duration):
            return true
        case (.timingFunction, .timingFunction):
            return true
        case (.repeat, .repeat):
            return true
        case (.autoreverse, .autoreverse):
            return true
        case (.completion, .completion):
            return true
        default:
            return false
        }
    }
    
}
