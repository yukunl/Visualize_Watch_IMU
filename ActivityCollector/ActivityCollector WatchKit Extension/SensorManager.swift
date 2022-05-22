//
//  SensorManager.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/18/22.
//

import Foundation
import HealthKit
import CoreMotion

class SensorManager: NSObject, ObservableObject{
//    var selectedActivity : Activity?
    
    @Published var showingSummaryView: Bool = false {
            didSet {
                if showingSummaryView == false {
//                    selectedActivity = nil
                }
            }
        }
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    var accX = 0.0
    var session: Bool = false
    
    override init() {
        
            
    }
    
    func start(){
        session = true
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
        session = false
//        motionManager.stopDeviceMotionUpdates()
        
    }
    
    func resume(){
        
    }
    
    func end(){
        
        motionManager.stopDeviceMotionUpdates()
        showingSummaryView = true
    }
    
}
