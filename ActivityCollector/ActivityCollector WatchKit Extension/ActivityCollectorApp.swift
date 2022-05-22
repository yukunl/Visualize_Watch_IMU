//
//  ActivityCollectorApp.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 3/18/22.
//

import SwiftUI

@main
struct ActivityCollectorApp: App {
    
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
