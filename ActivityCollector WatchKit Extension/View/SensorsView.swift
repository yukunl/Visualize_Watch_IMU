//
//  SensorsView.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/18/22.
//

import SwiftUI
//import CoreMotion
import SocketIO



struct SensorsView: View {
//    @ObservedObject var timeManager = TimerManager()
//    @EnvironmentObject var timeManager:TimerManager
////    @ObservedObject var timeManager = TimerManager()
//    @EnvironmentObject var heartRateManager: HeartRateManager
//    @EnvironmentObject var imuManager: IMUManager
    @EnvironmentObject var workoutManager: WorkoutManager

//    private var manager = SocketManager(socketURL: URL(string: "ws://10.0.0.66:3000")!, config: [.log(true), .compress])
    
    
//    init(){
//        socket = manager.defaultSocket
//    }
    
    var body: some View {
        ScrollView{
        VStack(alignment: .leading){
            Text(String(format: "%.2f", workoutManager.secondElapsed)).foregroundColor(Color.yellow)
                .fontWeight(.semibold)
            // Heart Rate
            VStack{
                        HStack{
                            Text(String(format: "%.2f", workoutManager.heartRate))
                                .fontWeight(.regular)
                                .font(.system(size: 40))
                            
                            Text("BPM")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                                .padding(.bottom, 18.0)
                        }
                    }
//            Text(String(format: "%.2f", workoutManager.heartRate)).foregroundColor(Color.red)
//                .fontWeight(.semibold)
            // IMU data
            Text("Pitch " + String(format: "%.2f", workoutManager.pitch)).foregroundColor(Color.white)
                .fontWeight(.light).font(.system(size: 25))
            Text("Roll " + String(format: "%.2f", workoutManager.roll)).foregroundColor(Color.white)
                .fontWeight(.light).font(.system(size: 25))
            Text("Yaw " + String(format: "%.2f", workoutManager.yaw)).foregroundColor(Color.white)
                .fontWeight(.light).font(.system(size: 25))
            Text("AccX " + String(format: "%.2f", workoutManager.accX)).foregroundColor(Color.white)
                .fontWeight(.light).font(.system(size: 25))
            Text("AccY " + String(format: "%.2f", workoutManager.accY)).foregroundColor(Color.white)
                .fontWeight(.light).font(.system(size: 25))
            Text("AccZ " + String(format: "%.2f", workoutManager.accZ)).foregroundColor(Color.white)
                .fontWeight(.light).font(.system(size: 25))
                
            
            
        }
        .font(.system(.title, design: .rounded)
                .monospacedDigit()
                .lowercaseSmallCaps()
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(edges: .bottom)
        .scenePadding()
        .onAppear{
//            heartRateManager.start()
//            workoutManager.socket.on(clientEvent: .connect) {(data, ack) in
//                print("apple watch Connected")
//                self.socket.emit("NodeJS Server Port", ["message" : "begin"])
//            }
//            socket.connect()
            print("on appear of the contentview")
        }.onChange(of: workoutManager.secondElapsed){ newValue in
            
            workoutManager.socket.emit("pythonPort", ["time" : Double(round(100*newValue)/100), "accX" : workoutManager.accX , "accY" : workoutManager.accY, "accZ" : workoutManager.accZ, "pitch" : workoutManager.pitch, "roll" : workoutManager.roll, "yaw" : workoutManager.yaw, "heart rate": workoutManager.heartRate])

        }
                        

            
        }
    }
}

struct SensorsView_Previews: PreviewProvider {
    static var previews: some View {
        SensorsView()
    }
}


