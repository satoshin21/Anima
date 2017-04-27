//
//  MoveViewController.swift
//  AnimaExample
//
//  Created by Satoshi Nagasaka on 2017/03/21.
//  Copyright © 2017年 satoshin21. All rights reserved.
//

import UIKit
import Anima

class MoveViewController: UIViewController {
    
    @IBOutlet weak var animaView: UIView!
    
    let timingFunction =
        TimingFunction.springManual(mass: 0.5, stiffness: 100, damping: 10, initialVelocity: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        animaView.backgroundColor = .animaView
        animaView.isUserInteractionEnabled = false
        animaView.layer.cornerRadius = 25
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(MoveViewController.anywhereTapped(gesture:)))
        self.view.addGestureRecognizer(touchGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func anywhereTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        
        animaView.layer.anima
            .then(.moveTo(x: location.x, y: location.y), options: [.timingFunction(timingFunction)]).fire()
    }
    
    @IBAction func moveY(_ sender: UIButton) {
    
        animaView.layer.anima
            .then(.moveByY(50), options: [.timingFunction(timingFunction)]).fire()
    }
    
    @IBAction func moveX(_ sender: UIButton) {
        
        animaView.layer.anima
            .then(.moveByX(50), options: [.timingFunction(timingFunction)]).fire()
    }
}
