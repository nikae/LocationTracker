//
//  ActivityCell.swift
//  Trail Lab
//
//  Created by Nika on 7/21/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ActivityCell: View {
    let activity: Activity

    var color: Color {
        return activity.activityType.color()
    }

    var isSpeedType: Bool {
        return activity.activityType.hkValue() == .cycling
    }

    var body: some View {
        VStack {
            SingleActivityTitleView(activity: activity)
                .padding(.bottom, 4)
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
        }
        .background(Color(.systemBackground))
        .padding(.vertical)
    }
}

struct ActivityCell_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCell(activity: MocActivity)
    }
}
