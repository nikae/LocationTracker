//
//  StandardOverlay.swift
//  Trail Lab
//
//  Created by Nika on 10/15/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        HStack {
            VStack(spacing: 2) {
                Image("Icon-App")
                    .resizable()
                    .cornerRadius(6)
                    .frame(width: 40, height: 40)

                Text("Trail Lab")
                    .font(.caption)
            }
            Spacer()
        }
        .padding(4)
    }
}

struct StandardOverlay: View {
    let activity: Activity
    let withTitle: Bool
    var isSpeedType: Bool {
        return activity.activityType.hkValue() == .cycling
    }

    var body: some View {
        VStack {
          Logo()
            Spacer(minLength: 10)
            if withTitle {
                HStack {
                    Text("\(activity.title ?? activity.activityType.name())".capitalized)
                        .font(Font.system(.headline, design: .rounded))
                        .foregroundColor(activity.activityType.color())
                        .padding(.horizontal, 4)
                    Spacer(minLength: 10)
                }
            }
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemBackground).opacity(0.2), Color(.systemBackground).opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom)

                HStack(alignment: .firstTextBaseline) {
                    self.StatsView(
                        value: activity.distance?.formatDistane() ?? "--",
                        title: "Distance".uppercased(),
                        tintColor: activity.activityType.color())
                        .frame(minWidth: 0, maxWidth: .infinity)
                    self.StatsView(
                        value: self.isSpeedType ? self.activity.speed?.formatSpeed() ?? "--" : self.activity.averagePace?.formatPace() ?? "-:-",
                        title: (self.isSpeedType ? "Avg Speed" : "Pace").uppercased(),
                        tintColor: activity.activityType.color())
                        .frame(minWidth: 0, maxWidth: .infinity)
                    self.StatsView(
                        value: self.activity.elevationGain?.formatAltitude() ?? "__",
                        title: "Elv Gain".uppercased(),
                        tintColor: activity.activityType.color())
                        .frame(minWidth: 0, maxWidth: .infinity)
                    self.StatsView(
                        value: self.activity.maxAltitude?.formatAltitude() ?? "--",
                        title: "Max Alt".uppercased(),
                        tintColor: activity.activityType.color())
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 2)
            }.frame(height: 40)
        }
    }
}

struct StandardOverlay_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StandardOverlay(activity: MocActivity, withTitle: true)
                .previewLayout(.fixed(width: 200.0, height: 150))
            StandardOverlay(activity: MocActivity, withTitle: true)
                .previewLayout(.fixed(width: 200.0, height: 150))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark  ode")
        }
    }
}
