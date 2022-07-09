//
//  SummaryView.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/18/22.
//

import SwiftUI

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            Text("Finished! Summary?")
            Button("Done"){
                dismiss()
            }.scenePadding()
            
            
        }
        
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
