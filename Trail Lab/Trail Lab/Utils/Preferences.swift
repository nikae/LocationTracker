//
//  Preferences.swift
//  Trail Lab
//
//  Created by Nika on 6/13/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
}

struct Preferences {
    @UserDefault("ACTIVITY_TYPE", defaultValue: ActivityType.walking.rawValue)
    static var activityType: Int
    @UserDefault("PREFERED_UNIT", defaultValue: getLocal().rawValue)
    static var unit: Int
    @UserDefault("DISTANCE_WEEKLY_GOAL", defaultValue: 16000.0)
    static var distanceGoal: Meter
    @UserDefault("TIME_WEEKLY_GOAL", defaultValue: 9000)
    static var timeGoal: TimeInterval
}

enum UnitPreferance: Int {
    case metric = 0
    case imperial = 1
}

/// Gets device local.
      /// This method is used to determin users default unit preferance before user explisitly sets it into the app setting
      /// - Returns: UnitPreferance based on device local
   func getLocal() -> UnitPreferance {
       //User region setting return
       let locale = Locale.current //NSLocale.current
       //Returns true if the locale uses the metric system (Note: Only three countries do not use the metric system: the US, Liberia and Myanmar.)
       let isMetric = locale.usesMetricSystem
       return isMetric ? .metric : .imperial
   }
