//
//  StatsView.swift
//  Trail Lab
//
//  Created by Nika Elashvili on 4/18/21.
//  Copyright © 2021 nika. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    @State var isAnimating = false
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 2) {
                Text("\(TimeInterval(activityManager.elapsedSeconds).format(unitsStyle: .positional, zeroFormattingBehavior: .pad) ?? "-:-:-")")
                    .font(Font.system(.title2, design: .rounded).monospacedDigit())
                    .foregroundColor(activityManager.activityType.color())
                
                Label {
                    Text("\(Int(activityManager.heartrate)) bpm")
                } icon: {
                   Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    .scaleEffect(self.isAnimating ? 1 : 0.8)
                }
                .font(Font.system(.title3, design: .rounded).monospacedDigit())
                .onAppear {
                    withAnimation(Animation.easeInOut.repeatForever()) {
                        self.isAnimating = true
                    }
                }
                
                Text("\(activityManager.activeCalories.formatCalories())")
                    .font(Font.system(.title3, design: .rounded).monospacedDigit())
                Text("\(activityManager.distance.formatDistane())")
                    .font(Font.system(.title3, design: .rounded).monospacedDigit())
                Text("\(activityManager.stepCount) Steps")
                    .font(Font.system(.title3, design: .rounded).monospacedDigit())
                Spacer()
                HStack {
                    Spacer()
                }
                
                //            Button("Start") {
                //                activityManager.startWorkout()
                //            }.background(Capsule().fill(Color.red))
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(ActivityManagerWatchOS())
    }
}
