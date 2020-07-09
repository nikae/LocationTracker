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
    @EnvironmentObject var activityHandler: ActivityHandler
    @EnvironmentObject var mapViewHandler: MapViewHandler 
    @State private var selectedTab = 1
    @State var playerFrame = CGRect.zero

    fileprivate func configureBottomCardSize(_ value: ScreenPreferance.Value) {
        let pos = (value.last?.viewSize.height ?? .zero)
        let safeAreaBottom = (value.last?.safeAreaInsets.bottom ?? .zero)
        let safeAreaTop = (value.last?.safeAreaInsets.top ?? .zero)
        self.dragBottomSheetHandler.viewHeight = pos + safeAreaBottom + safeAreaTop
        //This is not the best way to detect if device is X but works for now
        let a = pos - (safeAreaBottom == 0 ? safeAreaTop : 0)
        self.dragBottomSheetHandler.isSmallDevice = safeAreaBottom == 0
        self.dragBottomSheetHandler.position = a
        self.dragBottomSheetHandler.positionBelow = a
        self.dragBottomSheetHandler.positionAbove = a - 210
    }

    //FIXME: This needs to be moved into settings
    @State private var showGreeting = UnitPreferance(rawValue: Preferences.unit) == .metric

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                TabView(selection: self.$selectedTab) {
                    ZStack {
                        self.AppBackground()
                        //FIXME: This needs to be moved into settings
                        Toggle(isOn: self.$showGreeting) {
                            Text("Metric \(self.showGreeting ? "On" : "Off"): (Move into settings)")
                        }.padding()
                            .onReceive([self.showGreeting].publisher.first()) { (value) in
                                Preferences.unit = value ? UnitPreferance.metric.rawValue : UnitPreferance.imperial.rawValue
                        }

                    }
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("First")
                    }.tag(0)

                    WorkoutVIew()
                        .onAppear {
                            self.activityHandler.mapViewDelegate = self.mapViewHandler
                    }
                    .tabItem {
                        Text(self.selectedTab != 1 ?"Workout" :
                            self.activityHandler.activityButtonTitle)
                    }.tag(1)
                    HistoryView()
                    .environmentObject(HistoryViewHandler())
                        .tabItem {
                            Image(systemName: "3.circle")
                            Text("Profile")
                    }.tag(2)
                }
                .preference(
                    key: ScreenPreferance.self,
                    value: [Screen(
                        viewSize: proxy.frame(in: CoordinateSpace.global),
                        safeAreaInsets:proxy.safeAreaInsets)])
            }

            .onPreferenceChange(ScreenPreferance.self, perform: { value in
                self.configureBottomCardSize(value)
            })

            StartButton(selectedTab: $selectedTab)
                .shadow(color: Color( .sRGBLinear, white: 0, opacity: 0.2),
                        radius: 10.0)
        }
        .onAppear {
            self.activityHandler.authorizeHealthKit()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//TODO: Move those somewhere else
struct Screen: Equatable {
    let viewSize: CGRect
    let safeAreaInsets: EdgeInsets
}

struct ScreenPreferance: PreferenceKey {
    typealias Value = [Screen]
    static var defaultValue: [Screen] = []
    static func reduce(value: inout [Screen], nextValue: () -> [Screen]) {
        value.append(contentsOf: nextValue())
    }
}
