//
//  SingleActivityStatsView.swift
//  Trail Lab
//
//  Created by Nika on 7/18/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation

import SwiftUI


struct SingleActivityStatsView: View {
    let activity: Activity

    var color: Color {
        return activity.activityType.color()
    }

    var isSpeedType: Bool {
        return activity.activityType.hkValue() == .cycling
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .bottom) {
                self.StatsViewLarge(
                    value: (self.activity.end.timeIntervalSince(self.activity.start)).format() ?? "__",
                    title: "Duration".uppercased(),
                    tintColor: self.color)
                    .frame(minWidth: 0, maxWidth: .infinity)
                if self.isSpeedType {
                    self.StatsViewLarge(
                        value: (self.activity.calories ?? 0).formatCalories(),
                        title: "calories".uppercased(),
                        tintColor: self.color)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            if !self.isSpeedType  {
                Divider()
                HStack(alignment: .bottom) {
                    self.StatsViewLarge(
                        value: (self.activity.calories ?? 0).formatCalories(),
                        title: "calories".uppercased(),
                        tintColor: self.color)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    self.StatsViewLarge(
                        value: "\(self.activity.numberOfSteps ?? 0)",
                        title: "Steps".uppercased(),
                        tintColor: self.color)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            Divider()
            HStack(alignment: .bottom) {
                self.StatsViewLarge(
                    value: self.activity.distance?.formatDistane() ?? "--",
                    title: "Distance".uppercased(),
                    tintColor: self.color)
                    .frame(minWidth: 0, maxWidth: .infinity)

                self.StatsViewLarge(
                    value: self.isSpeedType ? self.activity.speed?.formatSpeed() ?? "--" : self.activity.averagePace?.formatPace() ?? "-:-",
                    title: (self.isSpeedType ? "Avg Speed" : "Pace").uppercased(),
                    tintColor: self.color)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            Divider()
            HStack(alignment: .bottom) {
                self.StatsViewLarge(
                    value: self.activity.elevationGain?.formatAltitude() ?? "__",
                    title: "Elev Gain".uppercased(),
                    tintColor: self.color)
                    .frame(minWidth: 0, maxWidth: .infinity)
                self.StatsViewLarge(
                    value: self.activity.reletiveAltitude?.formatAltitude() ?? "__",
                    title: "Relat Alt".uppercased(),
                    tintColor: self.color)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            Divider()
            HStack(alignment: .bottom) {
                if self.activity.minAltitude != nil {
                self.StatsViewLarge(
                    value: self.activity.minAltitude?.formatAltitude() ?? "--",
                    title: "Min Altitude".uppercased(),
                    tintColor: self.color)
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                self.StatsViewLarge(
                    value: self.activity.maxAltitude?.formatAltitude() ?? "--",
                    title: "Max Altitude".uppercased(),
                    tintColor: self.color)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}
