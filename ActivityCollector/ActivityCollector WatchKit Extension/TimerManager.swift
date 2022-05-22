//
//  TimerManager.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 4/8/22.
//

import Foundation

enum mode{
    case running
    case stopped
}


class TimerManager:ObservableObject,Equatable{
    
    
    @Published private(set) var secondElapsed = 0.0
    @Published private(set) var mode: mode = .stopped
    @Published var count = 0
    
    static func == (lhs: TimerManager, rhs: TimerManager) -> Bool {
        return lhs.secondElapsed == rhs.secondElapsed
    }
    
    var timer = Timer()
    func switchStartEnd(){
        if(count % 2 == 0){
            timer.invalidate()
            secondElapsed = 0.0
            mode = .stopped
            }
        else{
            mode = .running
            timer = Timer.scheduledTimer( withTimeInterval: 0.1, repeats: true){
                timer in self.secondElapsed += 0.1
            }
        }
        count += 1
    }
    

}
