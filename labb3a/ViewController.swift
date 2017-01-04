//
//  ViewController.swift
//  labb3a
//
//  Created by lucas persson on 2017-01-04.
//  Copyright © 2017 lucas persson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let manager = CMMotionManager()

    
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
            manager.accelerometerUpdateInterval = 0.01
            manager.startAccelerometerUpdates(to: OperationQueue.main) {
                [weak self] (data: CMAccelerometerData?, error: Error?) in
                //print(2)
                if let acceleration = data?.acceleration {
                    //print(3)
                    let rotation = atan2(acceleration.x, acceleration.y) - M_PI
                    
                    let label = self?.degreeLabel
                    label?.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                    label?.text = "\(rotation)°"
                }
            }
                }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var degreeLabel: UILabel!

}

