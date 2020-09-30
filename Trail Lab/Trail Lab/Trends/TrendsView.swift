//
//  TrendsView.swift
//  Trail Lab
//
//  Created by Nika on 7/8/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct TrendsView: View {
    @EnvironmentObject var historyViewHandler: HistoryViewHandler
    @State var showActivityList: Bool = false
    @State var showRecentActivity: Bool = false
    @State var routeWaypoint: [RouteWaypoint] = []
    @State var showMap: Bool = false
    @State var animateStats: Bool = false

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                GraphTile()
                VStack {
                HStack {
                    Text("Weekly Goals")
                        .font(.headline)
                        .foregroundColor(Color(.label))
                    Spacer()
                }
                .padding()

                HStack {
                    ProgressBar(
                        progress: self.$historyViewHandler.weeklyGoal.distanceProgress,
                        progressLabel: self.$historyViewHandler.weeklyGoal.distanceFormmated,
                        animated: $animateStats,
                        title: "Distance")
                        .frame(minWidth: 100, maxWidth: .infinity)
                        .frame(height: 130)
                        .onTapGesture {
                            self.historyViewHandler.showDistanceGoal.toggle()
                    }
                    ProgressBar(
                        progress: self.$historyViewHandler.weeklyGoal.timeProgress,
                        progressLabel: self.$historyViewHandler.weeklyGoal.timeFormmated,
                        animated: $animateStats,
                        title: "Time")
                        .frame(minWidth: 100, maxWidth: .infinity)
                        .frame(height: 130)
                    .onTapGesture {
                            self.historyViewHandler.showDurationGoal.toggle()
                    }
                }
                .onAppear {
                    self.animateStats = true
                }

                .padding()
                }
                 .background(self.AppBackground())

                Spacer()
            }
            .sheet(isPresented: $showActivityList) {
                VStack {
                    DismissIcon()
                    ActivitiesView()
                        .environmentObject(self.historyViewHandler)
                }
            }

//            if historyViewHandler.maxAltitudeList.count > 1{
//                linearGraph(dataPoints: historyViewHandler.maxAltitudeList)
//                    .onTapGesture {
//                        self.historyViewHandler.getMaxAltitudeList(forWeek: false)
//                }
//            }

            if historyViewHandler.activityList.last != nil {
                Divider()
                .padding(.horizontal)
                HStack {
                    Text("Recent Activity")
                        .font(.headline)
                        .foregroundColor(Color(.label))
                    Spacer()
                }
                .padding(.horizontal)
                SingleActivityTitleView(activity: historyViewHandler.activityList.first!)
                    .padding()
                    .onTapGesture {
                        self.showRecentActivity.toggle()
                }
                .sheet(isPresented: $showRecentActivity) {
                    SingleActivityView(
                        activity: self.historyViewHandler.activityList.first!,
                        isNewActivity: false)

                }
                SingleActivityStatsView(activity: historyViewHandler.activityList.first!)
                    .padding(.horizontal)
             //TODO: ADD MAPVIEW HERE
            }
        }
        .onAppear {
            let date = self.historyViewHandler.getMonday(.current, for: Date())
            self.historyViewHandler.getWorkoutsForAWeek(for: date, updateWidgetData: true)
        }
        .navigationBarItems(trailing:
            Button(action: {
                 self.showActivityList.toggle()
            }, label: {
                if !self.historyViewHandler.activityList.isEmpty {
                Image(systemName: "rectangle.grid.1x2.fill")
                }
            })
        )
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
