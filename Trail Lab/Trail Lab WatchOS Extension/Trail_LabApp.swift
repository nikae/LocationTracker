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
    @SceneBuilder var body: some Scene {
      
        WindowGroup {
//            if activityManager.running {
//                InActivityView()
//                    .environmentObject(activityManager)
//            } else {
            NavigationView {
                ContentView()
                    .environmentObject(activityManager)
//            }
        }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
