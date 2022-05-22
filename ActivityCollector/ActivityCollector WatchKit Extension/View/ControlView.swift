//
//  ControlView.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/18/22.
//

import SwiftUI

struct ControlView: View {
    
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var workoutManager: WorkoutManager
    
    
    var body: some View {
        HStack {
                    VStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .tint(Color.red)
                        .font(.title2)
                        Text("End")
                    }
                    VStack {
                        Button(action:{
                            workoutManager.switchStartEnd()
                        }, label: {
                            Image(systemName:"play")
                        }).tint(.white).font(.title2)
                        Text( "Start" )
                    }
                }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView().environmentObject(WorkoutManager())
    }
}
