//
//  MotionManager.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/18/22.
//

import Foundation
import CoreMotion

class MotionManager {
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    var accX = 0.0
    init() {
        
            
    }
    
    func start(){
        
        if !(motionManager.isDeviceMotionAvailable) {
                    print ("Device motion is unavailable")
                    return
                }
                
        if !(motionManager.isAccelerometerAvailable) {
                    print ("Accelerometer is unavailable")
                }
                
        if !(motionManager.isGyroAvailable) {
                    print ("Gyroscope is unavailable")
                }
                
        if !(motionManager.isMagnetometerAvailable) {
                    print ("Magnetometer is unavailable")
                }
                
                print("Start updates")
        motionManager.startDeviceMotionUpdates(to: queue){
            (data, error) in
             guard error == nil else {
                           print("Error")
                           return
                           }
            
            if let data = data {
                            
                self.accX = data.userAcceleration.x
                                
                        }
            
        }
    }
    
    func pause(){
        
        motionManager.stopDeviceMotionUpdates()
        
    }
    
    func resume(){
        
    }
    
    func end(){
        
    }
    
    
    
    
}
