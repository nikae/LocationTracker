//
//  InActivityView.swift
//  Trail Lab
//
//  Created by Nika Elashvili on 4/17/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUI
import Foundation
import WatchKit

struct InActivityView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    var body: some View  {
        TabView {
            EndView()
            StatsView()
            NowPlayingView()
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct InActivityView_Previews: PreviewProvider {
    static var previews: some View {
        InActivityView()
    }
}



struct EndView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    var body: some View {
        Button("Done", action: {
            activityManager.endWorkout()
        })
    }
}
