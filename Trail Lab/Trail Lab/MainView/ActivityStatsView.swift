//
//  ActivityStatsView.swift
//  Trail Lab
//
//  Created by Nika on 6/16/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ActivityStatsView: View {
    @EnvironmentObject var activityHandler: ActivityHandler
    @State var switchViews: Bool = false
    var color: Color {
        return activityHandler.activity?.activityType.color() ?? .gray
    }

    var isSpeedType: Bool {
        return activityHandler.activity?.activityType.hkValue() == .cycling
    }

    var body: some View {
        ZStack {
            AppBackground()
                .cornerRadius(12)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.4), radius: 10.0)
            if switchViews {
                VStack() {
                    //MARK: Duration, calories, Steps
                    self.StatsViewLarge(
                        value: self.activityHandler.activity?.duration.format() ?? "__",
                        title: "Duration".uppercased(),
                        tintColor: self.color,
                        larger: true)
                        .padding()
                    HStack {
                        self.StatsViewLarge(
                            value: self.activityHandler.activity?.distance?.formatDistane() ?? "--",
                            title: "Distance".uppercased(),
                            tintColor: self.color,
                            larger: true)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        self.StatsViewLarge(
                            value: self.isSpeedType ? self.activityHandler.activity?.speedCurrent?.formatSpeed() ?? "--" : activityHandler.activity?.averagePace?.formatPace() ?? "-:-",
                            title:self.isSpeedType ? "Speed".uppercased() : "Pace".uppercased(),
                            tintColor: self.color,
                            larger: true)
                            .frame(minWidth: 0, maxWidth: .infinity)

                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                }
            } else {
                VStack(spacing: 20) {
                    //MARK: Duration, calories, Steps
                    HStack {
                        StatsView(
                            value: activityHandler.activity?.duration.format() ?? "__",
                            title: "Duration".uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        StatsView(
                            value: activityHandler.activity?.totalEnergyBurned.formatCalories() ?? "--",
                            title: "calories".uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        StatsView(
                            value: isSpeedType ? activityHandler.activity?.speedCurrent?.formatSpeed() ?? "--" : "\(activityHandler.activity?.numberOfSteps ?? 0)",
                            title:isSpeedType ? "Speed".uppercased() : "Steps".uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }

                    //MARK: Distance, Pace/Speed, Elev Gain
                    HStack {
                        StatsView(
                            value: activityHandler.activity?.distance?.formatDistane() ?? "--",
                            title: "Distance".uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)

                        StatsView(
                            value: isSpeedType ? activityHandler.activity?.speed?.formatSpeed() ?? "--" : activityHandler.activity?.averagePace?.formatPace() ?? "-:-",
                            title: (isSpeedType ? "Avg Speed" : "Pace").uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        StatsView(
                            value: activityHandler.activity?.elevationGain?.formatAltitude() ?? "__",
                            title: "Elev Gain".uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)

                    }

                    //MARK: Reletive Alt, Altitude, Max Altitude
                    HStack {
                        StatsView(
                            value: activityHandler.activity?.reletiveAltitude?.formatAltitude() ?? "__",
                            title: "Rel Altitude".uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        StatsView(
                            value: activityHandler.activity?.altitude?.formatAltitude() ?? "--",
                            title: "Altitude".uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        StatsView(
                            value: activityHandler.activity?.maxAltitude?.formatAltitude() ?? "--",
                            title: "Max Altitude".uppercased(),
                            tintColor: color)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }

                }.padding(.horizontal)
            }
        }
        .onTapGesture {
            withAnimation {
                self.switchViews.toggle()
            }
        }
    }
}

struct ActivityStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityStatsView()
    }
}
