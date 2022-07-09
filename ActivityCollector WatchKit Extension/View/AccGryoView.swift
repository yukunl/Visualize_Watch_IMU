//
//  AccGryoView.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/23/22.
//

import SwiftUI
import CoreMotion

struct AccGryoView: View {
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let sampleInterval = 1.0/1
    
    @State private var pitch = Double.zero
    @State private var yaw = Double.zero
    @State private var roll = Double.zero
    
    @State private var accX = Double.zero
    @State private var accY = Double.zero
    @State private var accZ = Double.zero
    

    var body: some View {

        VStack{
            Text("Pitch " + pitch.formatted(.number.precision(.fractionLength(2))))
            Text("Yaw " + yaw.formatted(.number.precision(.fractionLength(2))))
            Text("Roll " + roll.formatted(.number.precision(.fractionLength(2))))
            Text("AccX " + accX.formatted(.number.precision(.fractionLength(2))))
            Text("AccY " + accY.formatted(.number.precision(.fractionLength(2))))
            Text("AccZ " + accZ.formatted(.number.precision(.fractionLength(2))))
            
        }.font(.system( .headline, design: .rounded)
            .monospacedDigit()
            .lowercaseSmallCaps()
          )
        .frame(alignment: .leading)
        .onAppear {
                print("ON APPEAR")
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
    }
}

struct AccelerometerView_Previews: PreviewProvider {
    static var previews: some View {
        AccGryoView()
    }
}
