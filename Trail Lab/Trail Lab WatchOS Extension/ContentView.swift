//
//  ContentView.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 4/17/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
        
        
        var body: some View {
            
            if activityManager.running {
                InActivityView()

            } else {
                ActivityStartView()
                    .onAppear(perform: {
                        activityManager.requestAuthorization()
                    })
            }
        }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
