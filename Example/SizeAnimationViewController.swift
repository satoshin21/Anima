//
//  SizeAnimationViewController.swift
//  AnimaExample
//
//  Created by Satoshi Nagasaka on 2017/03/22.
//  Copyright © 2017年 satoshin21. All rights reserved.
//

import UIKit
import Anima

class SizeAnimationViewController: UIViewController {
    
    @IBOutlet weak var animaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animations: [AnimaType] = [.scaleBy(1.5),
                                       .rotateByZDegree(360)]
        animaView.layer.anima.nextGroup(animations, options: [
            .autoreverse,
            .timingFunction(.easeInOut),
            .repeat(count: .infinity)])
            .fire()
        
    }
    
    let anchors: [AnimaAnchorPoint] = [.topLeft,
                                  .topRight,
                                  .bottomLeft,
                                  .bottomRight,
                                  .center]
    
    var currentAnchor:AnimaAnchorPoint = .center
    
    @IBAction func changeAnchor(_ sender: UIButton) {
        let nextAnchor: AnimaAnchorPoint = {
            
            switch currentAnchor {
            case .center:
                return .topLeft
            case .topLeft:
                return .topRight
            case .topRight:
                return .bottomLeft
            case .bottomLeft:
                return .bottomRight
            case .bottomRight:
                return .center
            default:
                fatalError()
            }
        }()
        
        animaView.layer.anima.next(.moveAnchor(nextAnchor)).fire()
        currentAnchor = nextAnchor
    }
}
