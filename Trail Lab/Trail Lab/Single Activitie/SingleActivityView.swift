//
//  SingleActivityView.swift
//  Trail Lab
//
//  Created by Nika on 7/14/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI


struct SingleActivityView: View {
    @ObservedObject var singleActivityViewHandler = SingleActivityViewHandler()
    let mapViewHandler: MapViewHandler = MapViewHandler()
    let activity: Activity
    let isNewActivity: Bool

    @State var routeWaypoint: [RouteWaypoint] = []
    @State var expendMap: Bool = false

    var body: some View {
        VStack {
            DismissIcon()
            GeometryReader { proxy in
                ZStack(alignment: .bottom) {
                    if self.singleActivityViewHandler.showMap {
                        ActivityMapView(routeWaypoints: self.routeWaypoint)
                            .cornerRadius(self.expendMap ? 0 : 12)
                            .frame(maxHeight: self.expendMap ? proxy.size.height : 200)
                            .padding(self.expendMap ? .top : .all)
                            .onTapGesture {
                                withAnimation {
                                    self.expendMap.toggle()
                                }
                        }
                    }
                    MapTypeChoices()

                        .background(Color(UIColor.background.primary)
                            .opacity(0.8)
                            .cornerRadius(8))
                        .frame(width: self.expendMap ? proxy.size.width - 100 : .zero)
                        .padding()
                }
                .environmentObject(self.mapViewHandler)
                Spacer()
            }
        }
        .onAppear {
            if self.isNewActivity {
                self.singleActivityViewHandler.getWaypointsFromLocalActivity(
                activity: self.activity) { waypoints in
                    if let waypoints = waypoints {
                        DispatchQueue.main.async {
                            self.routeWaypoint = waypoints
                            self.singleActivityViewHandler.showMap = true
                        }
                    }
                }
            } else {
                self.singleActivityViewHandler.getWaypointsFromHK(
                activity: self.activity) { waypoints in
                    if let waypoints = waypoints {
                        DispatchQueue.main.async {
                            self.routeWaypoint = waypoints
                            self.singleActivityViewHandler.showMap = true
                        }
                    }
                }
            }
        }
    }
}


struct SingleActivityView_Previews: PreviewProvider {
    static var previews: some View {
        SingleActivityView(
            activity: Activity(start: Date(), activityType: .walking, intervals: []),
            isNewActivity: true)
    }
}
