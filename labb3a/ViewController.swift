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
    @IBOutlet weak var magnetLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var gyroLabel: UILabel!
    var F = 0.90
    var magnet = 0.0{
        didSet{
            magnetLabel.text = Int(magnet).description
        }
    }
    var gyro = 0.0{
        didSet{
            gyroLabel.text = (gyro).description
        }
    }

    var acceler = 0.0{
        didSet{
            degreeLabel.text = Int(-180*acceler).description
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
                if let acceleration = data?.acceleration {
                      self?.acceler  = self!.F * self!.acceler + (1-self!.F) * acceleration.z
                    print(acceleration.z)

                }
            }
        }
        if manager.isGyroAvailable {
            //print(1)
            manager.gyroUpdateInterval = 0.1
            manager.startGyroUpdates(to: OperationQueue.main) {
                [weak self] (data: CMGyroData?, error: Error?) in
                //print(2)
                if let rate = data?.rotationRate {
                    self?.gyro = self!.F * self!.gyro + (1-self!.F) * rate.z
                    print(rate.z)
                }
            }
        }
        if manager.isMagnetometerAvailable {
            //print(1)
            manager.magnetometerUpdateInterval = 0.1
            manager.startMagnetometerUpdates(to: OperationQueue.main) {
                [weak self] (data: CMMagnetometerData?, error: Error?) in
                //print(2)
                if let rate = data?.magneticField {
                    self?.magnet = self!.F * self!.magnet + (1-self!.F) * rate.z
                    print(rate.z)

                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

