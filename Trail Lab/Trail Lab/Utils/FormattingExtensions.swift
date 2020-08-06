//
//  FormattingExtensions.swift
//  Trail Lab
//
//  Created by Nika on 6/25/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation

//MARK: Measurements
typealias Inch = Double
typealias Kilogram = Double
typealias Meter = Double
typealias MetersPerSecond = Double
typealias Second = Int
typealias SecondsPerMeter = Double

//MARK: Time
extension TimeInterval {
    func format(using units: NSCalendar.Unit = [.hour, .minute, .second]) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading

        return formatter.string(from: self)
    }
}

extension Double {
    //MARK: Speed
    func formatSpeed() -> String {
        let unit = UnitPreferance(rawValue: Preferences.unit)
        let unitSpeed: UnitSpeed = unit == .metric ? .kilometersPerHour : .milesPerHour
        let value = NSMeasurement(doubleValue: self, unit: UnitSpeed.metersPerSecond)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitOptions = .providedUnit
        let converted = value.converting(to: unitSpeed)
        return formatter.string(from: converted as Measurement<Unit>)
    }

    //MARK: Distane
    func formatDistane() -> String {
        let unit = UnitPreferance(rawValue: Preferences.unit)
        let unitLength: UnitLength = unit == .metric ? .kilometers : .miles
        let value = NSMeasurement(doubleValue: self, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitOptions = .providedUnit
        let converted = value.converting(to: unitLength)

        return formatter.string(from: converted as Measurement<Unit>)
    }

    //MARK: Distane
    func formatDistaneForGoals() -> String {
        let unit = UnitPreferance(rawValue: Preferences.unit)
        let unitLength: UnitLength = unit == .metric ? .kilometers : .miles
        let value = NSMeasurement(doubleValue: self, unit: unitLength)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitOptions = .providedUnit
        let converted = value.converting(to: unitLength)

        return formatter.string(from: converted as Measurement<Unit>)
    }

    func convert(fromMiters: Bool) -> Double {
        let unit = UnitPreferance(rawValue: Preferences.unit)
        let unitLength: UnitLength = unit == .metric ? .kilometers : .miles
        let value = NSMeasurement(doubleValue: self, unit: fromMiters ? UnitLength.meters : unitLength)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitOptions = .providedUnit
        let converted = value.converting(to: fromMiters ? unitLength : UnitLength.meters)

        return converted.value
    }
    

    //MARK: Pace
    func formatPace() -> String {
        let isMetric = UnitPreferance(rawValue: Preferences.unit) == .metric
        guard self != 0 && self != .infinity && self != -.infinity else {
            return ""
        }
        let convertedPace = isMetric ? self * 1000 : self * 1609
        let min = (Int(convertedPace) / 60) % 60
        let sec = Int(convertedPace) % 60
        return String(format: "%02d:%02d", min, sec)
    }

    //MARK: Calories
    func formatCalories() -> String {
        let value = NSMeasurement(doubleValue: self, unit: UnitEnergy.calories)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        return formatter.string(from: value as Measurement<Unit>)
    }

    //MARK: Altitude
    func formatAltitude() -> String {
        let unit = UnitPreferance(rawValue: Preferences.unit)
        let unitLength: UnitLength = unit == .metric ? .meters : .feet
        let value = NSMeasurement(doubleValue: self, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitOptions = .providedUnit
        let converted = value.converting(to: unitLength)

        return formatter.string(from: converted as Measurement<Unit>)
    }
}

//MARK: Localized
extension Date {
    var localizedStringTime: String {
        return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
    }

    var localaizedDate: String {
        return DateFormatter.localizedString(from: self, dateStyle: .full, timeStyle: .none)
    }
}

extension TimeInterval {
    func secondsToHoursMinutesSeconds() -> (hours: Int, minutes: Int, seconds: Int) {
        return (Int(self) / 3600, (Int(self) % 3600) / 60, (Int(self) % 3600) % 60)
    }
}

import HealthKit
struct Pace {
    static func calcPace(from meters: Double, over seconds: TimeInterval) -> TimeInterval? {
        guard meters > 0 && seconds > 0 else {
            return nil
        }
        return seconds / meters
    }
}
