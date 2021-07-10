//
//  DetailedStatsView.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 5/4/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUI

struct DetailedStatsView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    var body: some View {
        
        List {
            if activityManager.activity?.activityType == .biking {
                speed
                    .listRowPlatterColor(activityManager.activity?.activityType.color().opacity(0.15))
            } else {
                steps
                    .listRowPlatterColor(activityManager.activity?.activityType.color().opacity(0.15))
                pace
                    .listRowPlatterColor(activityManager.activity?.activityType.color().opacity(0.15))
            }
           
            Section(header: Text("Altitude"), content: {
                altitude
                    .listRowPlatterColor(activityManager.activity?.activityType.color().opacity(0.15))
                elevationGain
                    .listRowPlatterColor(activityManager.activity?.activityType.color().opacity(0.15))
                maxAltitude
                    .listRowPlatterColor(activityManager.activity?.activityType.color().opacity(0.15))
                minAltitude
                    .listRowPlatterColor(activityManager.activity?.activityType.color().opacity(0.15))
            })
        }
       
        //.listStyle(CarouselListStyle())
    }
    
    private var steps: some View {
        stat(value: "\(activityManager.activity?.numberOfSteps ?? 0)", title: "Steps")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private var speed: some View {
        stat(value: "\((activityManager.activity?.speedCurrent ?? 0).formatSpeed())", title: "Speed")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private var pace: some View {
        stat(value: "\((activityManager.activity?.averagePace ?? 0).formatPace())", title: "AV Pace")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private var elevationGain: some View {
        stat(value: "\((activityManager.activity?.elevationGain ?? 0).formatAltitude())", title: "Elv Gain")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private var altitude: some View {
        stat(value: "\((activityManager.activity?.altitude ?? 0).formatAltitude())", title: "Current")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private var minAltitude: some View {
        stat(value: "\((activityManager.activity?.minAltitude ?? 0).formatAltitude())", title: "Min")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private var maxAltitude: some View {
        stat(value: "\((activityManager.activity?.maxAltitude ?? 0).formatAltitude())", title: "Max")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    func stat(value: String,
              title: String) -> some View {
        return HStack {
            VStack(alignment: .leading ,spacing: 2) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.footnote)
                .lineLimit(1)
                .foregroundColor(activityManager.activity?.activityType.color())
                .minimumScaleFactor(0.5)
            
        }
            Spacer()
        }
    }
}

struct DetailedStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedStatsView()
            .environmentObject(ActivityManagerWatchOS())
    }
}
