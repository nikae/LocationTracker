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
                    ProgressBar(progress: self.$historyViewHandler.weeklyGoal.distanceProgress,
                                progressLabel: self.$historyViewHandler.weeklyGoal.distanceFormmated, title: "Distance")
                        .frame(minWidth: 100, maxWidth: .infinity)
                        .frame(height: 130)
                    ProgressBar(progress: self.$historyViewHandler.weeklyGoal.timeProgress, progressLabel: self.$historyViewHandler.weeklyGoal.timeFormmated, title: "Time")
                        .frame(minWidth: 100, maxWidth: .infinity)
                    .frame(height: 130)
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
                SingleActivityTitleView(activity: historyViewHandler.activityList.last!)
                    .padding()
                    .onTapGesture {
                        self.showRecentActivity.toggle()
                }
                .sheet(isPresented: $showRecentActivity) {
                    SingleActivityView(activity: self.historyViewHandler.activityList.last!, isNewActivity: false)

                           }
                SingleActivityStatsView(activity: historyViewHandler.activityList.last!,
                                        isNewActivity: false)
                    .padding(.horizontal)
             //TODO: ADD MAPVIEW HERE
            }
        }
        .onAppear {
            self.historyViewHandler.selectedDateForDraphs = Date()
            self.historyViewHandler.getWorkoutsForAWeek(for: self.historyViewHandler.selectedDateForDraphs)
        }
        .navigationBarItems(trailing:
            Button(action: {
                 self.showActivityList.toggle()
            }, label: { 
                Image(systemName: "rectangle.grid.1x2.fill")
            })
        )
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
