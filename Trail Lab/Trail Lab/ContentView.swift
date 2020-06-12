//
//  ContentView.swift
//  Trail Lab
//
//  Created by Nika on 6/9/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var dragBottomSheetHandler: DragBottomSheetHandler
    @State private var selectedTab = 1
     @State var playerFrame = CGRect.zero

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                TabView(selection: self.$selectedTab) {
                self.AppBackground()
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("First")
                }.tag(0)

                WorkoutVIew()
                    .environmentObject(self.dragBottomSheetHandler)
                    .tabItem {
                        Text( self.selectedTab != 1 ? "Workout" : "Start")
                }.tag(1)
                self.AppBackground()
                    .tabItem {
                        Image(systemName: "3.circle")
                        Text("Profile")
                }.tag(2)
            }
            .preference(key: Size.self, value: [proxy.frame(in: CoordinateSpace.global)])
            }

            .onPreferenceChange(Size.self, perform: { (v) in
                let a = (v.last?.height ?? .zero) - 10
                self.dragBottomSheetHandler.position = a
                self.dragBottomSheetHandler.positionBelow = a
                self.dragBottomSheetHandler.positionAbove = a - 300
                print("self.playerFrame \(self.playerFrame.height)")
            })

            StartButton(selectedTab: $selectedTab)
                .environmentObject(dragBottomSheetHandler)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Size: PreferenceKey {

    typealias Value = [CGRect]
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}
