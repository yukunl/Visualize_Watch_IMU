//
//  IMUManager.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 4/11/22.
//

import Foundation
import CoreMotion

class IMUManager:ObservableObject{
   
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let sampleInterval = 1.0/1
    
    @Published var count = 0
    @Published private(set) var pitch = Double.zero
    @Published private(set) var yaw = Double.zero
    @Published private(set) var roll = Double.zero
    
    @Published private(set) var accX = Double.zero
    @Published private(set) var accY = Double.zero
    @Published private(set) var accZ = Double.zero
    
    func imuSwitch(){
        if(count % 2 == 0){
            pitch = Double.zero
            yaw = Double.zero
            roll = Double.zero
            accX = Double.zero
            accY = Double.zero
            accZ = Double.zero
        }else{
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else {
                    print("Error: \(error!)")
                    return
                }
                let attitude: CMAttitude = data.attitude
                let acceleration: CMAcceleration = data.userAcceleration
                
                print("pitch: \(attitude.pitch)")
                print("yaw: \(attitude.yaw)")
                print("roll: \(attitude.roll)")
                
                print("accX: \(acceleration.x)")
                print("accY: \(acceleration.y)")
                print("accZ: \(acceleration.z)")

                DispatchQueue.main.async {
                    self.pitch = attitude.pitch
                    self.yaw = attitude.yaw
                    self.roll = attitude.roll
                    self.accX = acceleration.x
                    self.accY = acceleration.y
                    self.accZ = acceleration.z
                }
            }
        self.motionManager.deviceMotionUpdateInterval = sampleInterval
        }
        count = count + 1
        
    }
    

}
