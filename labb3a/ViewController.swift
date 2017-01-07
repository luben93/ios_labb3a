//
//  ViewController.swift
//  labb3a
//
//  Created by lucas persson on 2017-01-04.
//  Copyright © 2017 lucas persson. All rights reserved.
//  inspired by: http://nshipster.com/cmdevicemotion/

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var magnetLabel: UILabel!//X
    @IBOutlet weak var degreeLabel: UILabel!//Y
    @IBOutlet weak var gyroLabel: UILabel!//Z
    @IBOutlet var background: UIView!
    static let F = 0.90
    let manager = CMMotionManager()
    var shakes = 0
    var timer = Timer()
    var timer2 = Timer()
    var shaking = false
    var filtered = ThreeAxis()
    var noGravity = ThreeAxis()
    var tilt = ThreeAxis(){
        didSet{
            magnetLabel.text = Int(tilt.x * 180 / M_PI).description
            degreeLabel.text = Int(tilt.y * 180 / M_PI).description
            gyroLabel.text = Int(tilt.z * 180 / M_PI).description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        startAcc()
    }
    
    func startAcc(){
        if manager.isAccelerometerAvailable {
            //print(1)
            manager.accelerometerUpdateInterval = 0.1
            manager.startAccelerometerUpdates(to: OperationQueue.main) {
                [weak self] (data: CMAccelerometerData?, error: Error?) in
                //print(2)
                if let instance = self {
                    instance.filtered.filter(new: data!.acceleration)
                    instance.tilt.angle(new: instance.filtered)
                    instance.noGravity.deGravitaite(raw: data!.acceleration, filterd: instance.filtered)
                    if instance.noGravity.maxValue() > 1 {
                        if !instance.timer.isValid {
                            instance.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(instance.updateColor), userInfo: nil, repeats: false)
                        }
                        if instance.timer2.isValid {
                            instance.timer2.invalidate()
                        }
                    }else{
                        if instance.timer.isValid {
                            instance.shakes += 1
                        }
                        if !instance.timer2.isValid {
                            instance.timer2 = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector: #selector(instance.invalidateTime), userInfo: nil, repeats: false)
                        }
                    }
                }
            }
        }
    }
    
    func invalidateTime(){
        if(self.timer.isValid){
            self.timer.invalidate()
            shakes = 0
        }
    }
    
    func updateColor(){
        if shakes <= 3{
            shakes = 0
            timer.invalidate()
            return
        }
       
        background.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        timer.invalidate()
        shakes = 0
    }
    
    struct ThreeAxis {
        private(set) var x = 0.0
        private(set) var y = 0.0
        private(set) var z = 0.0
        mutating func filter(new:CMAcceleration){
            x = F * self.x + (1 - F) * new.x
            y = F * self.y + (1 - F) * new.y
            z = F * self.z + (1 - F) * new.z
        }
        mutating func angle(new:ThreeAxis){
            x = atan( new.x / sqrt(pow(new.y,2) + pow(new.z,2)))
            y = atan( new.y / sqrt(pow(new.x,2) + pow(new.z,2)))
            z = atan( sqrt(pow(new.x,2) + pow(new.y,2)) / new.z)//nan because of this row
        }
        mutating func deGravitaite(raw:CMAcceleration ,filterd:ThreeAxis){
            x = raw.x - filterd.x
            y = raw.y - filterd.y
            z = raw.z - filterd.z
        }
        func maxValue()->Double{
            return Double.maximum(Double.maximum(self.x, self.y), self.z)
        }
    }
}
