//
//  HistoryViewHandler.swift
//  Trail Lab
//
//  Created by Nika on 6/26/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import HealthKit

class HistoryViewHandler: ObservableObject {
    @Published var activityList: [Activity] = []

    func getActivityList() {
        ActivityDataStore.loadPrancerciseWorkouts{ activityList, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "No activity")
                return
            }

            guard let activityList = activityList else {
                print("No activity")
                return
            }

            func localValue(_ t: HKWorkoutActivityType) -> ActivityType {
                switch t {
                case .walking:
                    return .walking
                case .running:
                    return .running
                case .hiking:
                    return .hiking
                case .cycling:
                    return .biking
                default:
                    return .walking
                }
            }

            var list: [Activity] = []
            for activity in activityList {
                let startDate = activity.startDate
                let workoutActivityType = activity.workoutActivityType
                list.append(Activity(
                    start: startDate,
                    activityType: localValue(workoutActivityType),
                    intervals: []))
            }
            self.activityList = list
        }
    }
}
