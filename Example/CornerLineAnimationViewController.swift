//
//  CornerLineAnimationViewController.swift
//  AnimaExample
//
//  Created by Satoshi Nagasaka on 2017/04/24.
//  Copyright © 2017 satoshin21. All rights reserved.
//

import Foundation
import Anima

class CornerLineAnimationViewController: UIViewController {
    
    @IBOutlet weak var animaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = AnimaType.scaleBy(2.0)
        let cornerRadius = AnimaType.cornerRadius(25)
        let borderColor = AnimaType.borderColor(.white)
        let borderWidth = AnimaType.borderWidth(5)
        animaView.layer
            .anima
            .nextGroup([size, cornerRadius, borderColor, borderWidth], options: [.timingFunction(.easeOutCubic),.duration(1.5), .autoreverse, .repeat(count: .infinity)])
            .fire()
    }
    
}
