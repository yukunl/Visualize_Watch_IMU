//
//  ContentView.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/18/22.
//

import SwiftUI


struct ContentView: View {
    
    
    var activityTypes: [Activity] = [Activity(id: 0, name: "Coughing" ), Activity(id: 1, name: "Clapping"), Activity(id: 2, name: "Swimming" ), Activity(id: 3, name: "Cooking" ), Activity(id: 4, name: "Sleeping"), Activity(id: 5, name: "Typing" )]
    
    var body: some View {
                List(activityTypes){
                    activityType in
                    NavigationLink(
                        activityType.name,
                        destination: SessionPagingView()
                    ).padding(
                        EdgeInsets(top:15, leading: 5, bottom:15, trailing: 5))
                }.listStyle(.carousel)
                    .navigationBarTitle("Activities")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
