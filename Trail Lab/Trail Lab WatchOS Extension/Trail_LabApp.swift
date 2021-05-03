//
//  Trail_LabApp.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 4/17/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUI

@main
struct Trail_LabApp: App {
    @ObservedObject var activityManager = ActivityManagerWatchOS()
    @ObservedObject var contentViewHandler = ContentViewHandler.shared
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(contentViewHandler)
                    .environmentObject(activityManager)
            }
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
