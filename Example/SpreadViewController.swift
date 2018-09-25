//
//  SpreadViewController.swift
//  AnimaExample
//
//  Created by Satoshi Nagasaka on 2017/03/21.
//  Copyright © 2017年 satoshin21. All rights reserved.
//

import UIKit
import Anima

class SpreadViewController: UIViewController {

    @IBOutlet weak var animaView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [animaView,
         label1,
         label2,
         label3,
         label4,
         label5].forEach({$0.layer.opacity = 0})

        Anima.defaultTimingFunction = .easeOut
        Anima.defaultDuration = 0.5
        
        let startAnimations: [AnimaType] = [.moveByY(-50), .rotateByZDegree(90)]
        let moveAnimations: [AnimaType] = [.moveByX(50), .rotateByZDegree(90)]
        let endAnimations: [AnimaType] = [.moveByY(-50), .rotateByZDegree(90)]
        
        animaView.layer.anima
            .then(.opacity(1.0))
            .then(group: startAnimations)
            .then(group: moveAnimations, options: labelAnimaOption(index: 0))
            .then(group: moveAnimations, options: labelAnimaOption(index: 1))
            .then(group: moveAnimations, options: labelAnimaOption(index: 2))
            .then(group: moveAnimations, options: labelAnimaOption(index: 3))
            .then(group: endAnimations, options: labelAnimaOption(index: 4))
            .then(group: [.scaleBy(0.0), AnimaType.opacity(0.0)])
            .fire(completion: {[weak self] in
                
                guard let `self` = self else {
                    return
                }
                
                [self.label1,
                 self.label2,
                 self.label3,
                 self.label4,
                 self.label5]
                    .compactMap { $0?.layer.anima }
                    .forEach {
                 
                        $0.then(.opacity(0.0)).fire()
                        
                }
                self.perform(#selector(SpreadViewController.segueList), with: nil, afterDelay: 1)
                
            })
    }
    
    @objc
    func segueList() {
        performSegue(withIdentifier: "segueList", sender: nil)
    }
    
    func labelAnimaOption(index: Int) -> [AnimaOption] {
        let labelAnima = [label1,
                      label2,
                      label3,
                      label4,
                      label5][index]?.layer.anima
        
        return [.completion({
            
            labelAnima?.then(.opacity(1)).fire()
        })]
    }
}
