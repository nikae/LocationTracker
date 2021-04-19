//
//  ActivityPlatter.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 4/17/21.
//  Copyright © 2021 nilka. All rights reserved.
//

import SwiftUI

struct ActivityPlatter: View {
    @EnvironmentObject var activityManager: ActivityManagerWatchOS
    let activity: ActivityType
    var body: some View {
        Button(action: {
            activityManager.activityType = activity
            activityManager.startWorkout(activity.hkValue())
        }, label: {
            HStack {
                Spacer()
            VStack(spacing: 8) {
                Image(activity.imageName())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                Text(activity.name().capitalized)
                    .font(.system(.body))
            }
            .foregroundColor(activity.color())
                Spacer()
            }
        })
    }
}

struct ActivityPlatter_Previews: PreviewProvider {
    static var previews: some View {
        ActivityPlatter(activity: ActivityType.walking)
    }
}

