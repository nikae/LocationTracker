//
//  ActivityHandler.swift
//  Trail Lab
//
//  Created by Nika on 6/13/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import HealthKit
import SwiftUI

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
}

struct Activity {
    let activityType: ActivityType

}

class ActivityHandler: ObservableObject {
    @Published var selectedActivityType: ActivityType = ActivityType(rawValue:Preferences.activityType) ?? .walking
    @Published var activityButtonTitle: String = "Start"

}

