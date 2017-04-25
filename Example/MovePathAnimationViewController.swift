//
//  MovePathAnimationViewController.swift
//  AnimaExample
//
//  Created by Satoshi Nagasaka on 2017/03/23.
//  Copyright © 2017年 satoshin21. All rights reserved.
//

import UIKit
import Anima

class MovePathAnimationViewController: UIViewController {

    @IBOutlet weak var animaView: UIView!
    var previousTimeStamp: TimeInterval = 0
    var locationArray: [CGPoint]? = nil
    var timeStamps: [TimeInterval]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let event = event else {
            return
        }
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        let timeSincePrevious =  previousTimeStamp == 0 ? 0 : event.timestamp - previousTimeStamp
        if locationArray == nil {
            locationArray = [CGPoint]()
        }
        if timeStamps == nil {
            timeStamps = [TimeInterval]()
        }
        
        locationArray?.append(location)
        timeStamps?.append(timeSincePrevious)
        self.previousTimeStamp = event.timestamp

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let locationArray = locationArray, let timeStamps = timeStamps else {
            return
        }
        
        let path = CGMutablePath()
        locationArray.forEach { (point) in
            if point == locationArray.first {
                path.move(to: point)
            } else {
                
                path.addLine(to: point)
            }
        }
        let sumTimeInterval = timeStamps.reduce(0, +)
        var keytime: TimeInterval = 0
        let keyTimes: [Double] = timeStamps.map { (double) -> Double in
            let key = double / sumTimeInterval + keytime
            keytime = key
            return key
        }
        
        let movePath = AnimaType.movePath(path: path, keyTimes: keyTimes)
        
        animaView.layer.anima.next(movePath,
                                   options: [.duration(sumTimeInterval)]).fire()
        
        self.locationArray = nil
        self.timeStamps = nil
        self.previousTimeStamp = 0
    }
    
    func distanceBetween(p1: CGPoint, p2: CGPoint) -> Float {
        let x = pow(p2.x - p1.x, 2)
        let y = pow(p2.y - p1.y, 2)
        return sqrt(Float(x) + Float(y))
    }
}

