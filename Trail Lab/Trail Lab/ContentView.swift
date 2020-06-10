//
//  ContentView.swift
//  Trail Lab
//
//  Created by Nika on 6/9/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Data")
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("First")
            }.tag(0)
            Text("Second View")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Main")
            }.tag(1)
            Text("Second View")
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Profile")
            }.tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
