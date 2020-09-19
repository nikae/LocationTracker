//
//  ActivityDataModel.swift
//  Trail Lab
//
//  Created by Nika on 9/19/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI
import HealthKit
import CoreLocation


enum ActivityType: Int {
    case walking = 1
    case running = 2
    case hiking = 3
    case biking = 4

    func hkValue() -> HKWorkoutActivityType {
        switch self {
        case .walking:
            return .walking
        case .running:
            return .running
        case .hiking:
            return .hiking
        case .biking:
            return .cycling
        }
    }

    func name() -> String {
        switch self {
        case .walking:
            return "walking"
        case .running:
            return "running"
        case .hiking:
            return "hiking"
        case .biking:
            return "biking"
        }
    }

    func title() -> String {
        switch self {
        case .walking:
            return "walk"
        case .running:
            return "run"
        case .hiking:
            return "hike"
        case .biking:
            return "bike ride"
        }
    }

    func imageName() -> String {
        switch self {
        case .walking:
            return "walking"
        case .running:
            return "running"
        case .hiking:
            return "trekking"
        case .biking:
            return "cycling"
        }
    }

    func color() -> Color {
        switch self {
        case .walking:
            return Color(UIColor.SportColors.walk)
        case .running:
            return Color(UIColor.SportColors.run)
        case .hiking:
            return Color(UIColor.SportColors.hike)
        case .biking:
            return Color(UIColor.SportColors.bike)
        }
    }

    func uiColor() -> UIColor {
        switch self {
        case .walking:
            return UIColor.SportColors.walk
        case .running:
            return UIColor.SportColors.run
        case .hiking:
            return UIColor.SportColors.hike
        case .biking:
            return UIColor.SportColors.bike
        }
    }
}

enum ActivityState {
    case active
    case inactive
    case paused
}

struct Activity {
    let id = UUID()
    let activityType: ActivityType
    var start: Date
    var hkValue: HKWorkout?
    var title: String?
    var end: Date
    var intervals: [ActivityInterval]
    var locations: [CLLocation] = []

    var numberOfSteps: Int?
    var distance: Meter?
    var pace: SecondsPerMeter?
    var speedCurrent: MetersPerSecond?
    var averagePace: SecondsPerMeter?
    var floorsAscended: Int?
    var floorsDscended: Int?
    var cadence: Double?
    var elevationGain: Meter?
    var reletiveAltitude: Meter?
    var altitude: Meter?
    var maxAltitude: Meter?
    var minAltitude: Meter?

    var calories: Double?

    init(start: Date,
         end: Date,
         activityType: ActivityType,
         title: String? = nil,
         hkValue: HKWorkout? = nil,
         intervals: [ActivityInterval],
         calories: Double? = nil,
         distance: Meter? = nil,
         numberOfSteps: Int? = nil,
         averagePace: SecondsPerMeter? = nil,
         elevationGain: Meter? = nil,
         reletiveAltitude: Meter? = nil,
         maxAltitude: Meter?  = nil,
         minAltitude: Meter?  = nil) {
        self.start = start
        self.end = end
        self.hkValue = hkValue
        self.activityType = activityType
        self.title = title
        self.intervals = intervals
        self.distance = distance
        self.numberOfSteps = numberOfSteps
        self.averagePace = averagePace
        self.elevationGain = elevationGain
        self.reletiveAltitude = reletiveAltitude
        self.maxAltitude = maxAltitude
        self.minAltitude = minAltitude
        self.calories = calories
    }

    var totalEnergyBurned: Double {
        return intervals.reduce(0) { (result, interval) in
            result + interval.totalEnergyBurned
        }
    }

    var duration: TimeInterval {
        let timeInterval = end.timeIntervalSince(start)
        return intervals.isEmpty ? timeInterval :  intervals.reduce(0) { (result, interval) in
            result + interval.duration
        }
    }

    var speed: MetersPerSecond? {
        if let distance = distance, duration > 0 {
            return distance / duration
        } else {
            return nil
        }
    }
}

struct ActivityInterval {
    var start: Date
    var end: Date

    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }

    var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }

    var totalEnergyBurned: Double {
        let prancerciseCaloriesPerHour: Double = 450
        let hours: Double = duration / 3600
        let totalCalories = prancerciseCaloriesPerHour * hours
        return totalCalories
    }
}

enum MetadataKeys: String {
    case stepsCount = "Steps Count"
    case elevationGain = "Elevation Gain"
    case reletiveAltitude = "Reletive Altitude"
    case maxAltitude = "Max Altitude"
    case minAltitude = "Min Altitude"
    case title = "Title"
}
