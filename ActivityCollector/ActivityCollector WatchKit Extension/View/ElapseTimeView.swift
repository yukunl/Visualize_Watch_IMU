//
//  ElapseTimeView.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/21/22.
//

import SwiftUI

struct ElapseTimeView: View {
    var body: some View {
        Text(Date.now, style: .timer)
            .foregroundColor(Color.yellow)
            .fontWeight(.semibold)
       }
}



struct ElapseTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ElapseTimeView()
    }
}
