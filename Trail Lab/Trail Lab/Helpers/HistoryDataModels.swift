//
//  HistoryDataModels.swift
//  Trail Lab
//
//  Created by Nika on 9/19/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation

struct ActivitiesByDay {
    var date: Date
    var activitys: [Activity]?
}

struct ActivitiesByWeek {
    var date: Date
    var activitys: [ActivitiesByDay]?
}

enum graphDirection {
    case previous
    case next
    case current
}

struct WeeklyGoal {
    var distance: Meter
    var distanceGoal: Meter
    var distanceProgress: Float
    var distanceFormmated: String

    var time: TimeInterval
    var timeGoal: TimeInterval
    var timeProgress: Float
    var timeFormmated: String
}
