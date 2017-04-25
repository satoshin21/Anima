//
//  PauseResumeAnimationViewController.swift
//  AnimaExample
//
//  Created by Satoshi Nagasaka on 2017/04/24.
//  Copyright © 2017 satoshin21. All rights reserved.
//

import UIKit
import Anima

class PauseResumeAnimationViewController: UIViewController {
    
    @IBOutlet weak var animaView: UIView!
    
    private var anima: Anima?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireAnimation()
        
    }
    
    private func fireAnimation() {
        
        let rotate = AnimaType.rotateByZDegree(360)
        let anima = animaView.layer.anima
        anima
            .nextGroup([.moveByX(100), rotate])
            .nextGroup([.moveByY(100), rotate])
            .nextGroup([.moveByX(-100), rotate])
            .nextGroup([.moveByY(-100), rotate]).fire { [weak self] in
                self?.fireAnimation()
        }
        self.anima = anima
    }

    @IBAction func toggleButtonClicked(_ sender: UIButton) {
        
        switch anima?.status {
        case .paused?, .willPaused?:
            anima?.resume()
        case .active?:
            anima?.pause()
        default:
            return
        }
    }
}
