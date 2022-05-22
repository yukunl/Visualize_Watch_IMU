//
//  SessionPagingView.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/18/22.
//

import SwiftUI

struct SessionPagingView: View {
    @State private var selection: Tab = .sensors
    @ObservedObject var workoutManager = WorkoutManager()
  
    
    enum Tab {
        case controls, sensors
    }
    var body: some View {
        TabView(selection: $selection){
            ControlView().tag(Tab.controls)
                .environmentObject(workoutManager)
            SensorsView().tag(Tab.sensors)
                .environmentObject(workoutManager)
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView().environmentObject(WorkoutManager())
    }
}
