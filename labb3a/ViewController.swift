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

    let manager = CMMotionManager()
    @IBOutlet weak var magnetLabel: UILabel!//X
    @IBOutlet weak var degreeLabel: UILabel!//Y
    @IBOutlet weak var gyroLabel: UILabel!//Z
    static let F = 0.90
    
    var tilt = ThreeAxis()
    var acceleration = ThreeAxis(){
        didSet{
            magnetLabel.text = Int(acceleration.x * 180 ).description
            degreeLabel.text = Int(acceleration.y * 180 ).description
            gyroLabel.text = Int(acceleration.z * 180 ).description
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
                 self?.acceleration.filter(new: data!.acceleration)
                
            }
        }
            
    }

    struct ThreeAxis {
        var x = 0.0
        var y = 0.0
        var z = 0.0
        mutating func filter(new:CMAcceleration){
            x = F * self.x + (1 - F) * new.x
            y = F * self.y + (1 - F) * new.y
            z = F * self.z + (1 - F) * new.z
        }
    }

}

