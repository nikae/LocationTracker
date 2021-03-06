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
    @State private var selection = 1
    
    var body: some View  {
        TabView(selection: $selection) {
            ControlsView().tag(0)
            StatsView().tag(1)
            DetailedStatsView().tag(2)
            NowPlayingView().tag(3)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct InActivityView_Previews: PreviewProvider {
    static var previews: some View {
        InActivityView()
    }
}

