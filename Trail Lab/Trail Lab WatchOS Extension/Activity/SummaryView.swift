//
//  SummaryView.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 5/25/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUI
import MapKit

struct SummaryView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    @EnvironmentObject var contentViewHandler: ContentViewHandler
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var body: some View {
        ScrollView {
            header(activityManager.activity?.title ?? activityManager.activity?.activityType.name().capitalized ?? "", divider: false)
                .foregroundColor(activityManager.activity?.activityType.color())
                .padding(.horizontal)
//            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
//                .frame(height: 120)
//                .cornerRadius(8)
//                .padding(.horizontal)
            VStack {
                duration
                header("Stats")
                distance
                calories
                if activityManager.activity?.activityType == .biking {
                    speed
                } else {
                    if activityManager.activity?.numberOfSteps ?? 0 > 0 {
                        steps
                    }
                    pace
                }
                
                header("Altitude")
                    .padding(.top)
                altitude
                elevationGain
                maxAltitude
                minAltitude
                
            }.padding(.horizontal)
            //.foregroundColor(activityManager.activity?.activityType.color())
           
            //
            Button(action: {activityManager.resetWorkout()},
                   label: {
                    Text("Done")
                   })
                .accentColor(activityManager.activity?.activityType.color())
                .padding()
        }
    }
    
    private func header(_ text: String, divider: Bool = true) -> some View {
        VStack {
            HStack {
                Text(text)
                    .font(.headline)
                    .opacity(0.5)
                Spacer()
            }
            if divider {
                Divider()
            }
        }
    }
    
    
    
    private var calories: some View {
        stat(value:"\(activityManager.activity?.calories?.formatCalories() ?? "--")", title: "Calories")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    private var distance: some View {
        stat(value:"\(activityManager.activity?.distance?.formatDistane() ?? "--")", title: "Distance")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private var duration: some View {
        stat(value: "\(TimeInterval(activityManager.elapsedSeconds).format(unitsStyle: .positional, zeroFormattingBehavior: .pad) ?? "-:-:-")", title: "")
            .frame(minWidth: 0, maxWidth: .infinity)
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
                    .foregroundColor(activityManager.activity?.activityType.color())
                Text(title)
                    .font(.footnote)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            Spacer()
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
            .environmentObject(ActivityManagerWatchOS())
    }
}
