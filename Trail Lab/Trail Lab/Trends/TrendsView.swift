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
    @State var routeWaypoint: [RouteWaypoint] = []
    @State var showMap: Bool = false

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                GraphTile()
                HStack {
                    Text("Goals")
                        .font(.headline)
                        .foregroundColor(Color(.label))
                        .onTapGesture {
                            self.showActivityList.toggle()
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }
            .sheet(isPresented: $showActivityList) { 
                HistoryView()
                    .environmentObject(self.historyViewHandler)
            }

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
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
