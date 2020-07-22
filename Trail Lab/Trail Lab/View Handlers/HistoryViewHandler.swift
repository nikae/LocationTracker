//
//  HistoryViewHandler.swift
//  Trail Lab
//
//  Created by Nika on 6/26/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import HealthKit
import SwiftUI

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

class HistoryViewHandler: ObservableObject {

    let distanceGoal = 16000.0
    let timeGoal: TimeInterval = 10800


    @Published var activityList: [Activity] = []
    @Published var selectedActivity: Activity =
        Activity(start: Date(), end: Date(), activityType: .walking, hkValue: nil, intervals: [], distance: 0)
    @Published var activityListWeekly: [ActivitiesByWeek] = []
    var maxAltitudeList: [CGFloat] = []
    var selectedDateForDraphs: Date = Date()
    @Published var barGraphModels: [BarGraphModel] = []
    @Published var dateTitle: String = ""
    @Published var weeklyGoal: WeeklyGoal = WeeklyGoal(
        distance: 0,
        distanceGoal: 16000.0,
        distanceProgress: 0,
        distanceFormmated: "--",
        time: 0,
        timeGoal: 3600,
        timeProgress: 0,
        timeFormmated: "--")

    func getGoals(activitiesByWeek: ActivitiesByWeek) {
        var totalDistance: Meter = 0
        var totalDuration: TimeInterval = 0

        guard let weekActivitys =  activitiesByWeek.activitys else { return }

        for activitieByDay in weekActivitys {
            if let activities = activitieByDay.activitys {
                for activitie in activities {
                    totalDistance += activitie.distance ?? 0
                    totalDuration += activitie.end.timeIntervalSince(activitie.start)
                }
            }
        }

        let distanceFormmated = "\(totalDistance.formatDistane()) / \n\(distanceGoal.formatDistane())"
        let timeFormmated = "\(totalDuration.format(using: [.hour, .minute]) ?? "--") / \n\(timeGoal.format(using: [.hour, .minute]) ?? "--")"

        self.weeklyGoal = WeeklyGoal(
            distance: totalDistance,
            distanceGoal: distanceGoal,
            distanceProgress: Float(totalDistance / distanceGoal),
            distanceFormmated:distanceFormmated,
            time: totalDuration,
            timeGoal: timeGoal,
            timeProgress: Float(totalDuration / timeGoal),
            timeFormmated: timeFormmated)

    }

    func getWorkoutsForAWeek(for date: Date) {
        let arr = getWeekdays(for: date)
        var activitiesByWeek = [ActivitiesByWeek]()
        var activitiesByDay = [ActivitiesByDay]()

        for i in arr {

            let dayArr = activityList.filter {
                Calendar.current.isDate($0.start, inSameDayAs: i) }
            let activities = ActivitiesByDay(
                date: i,
                activitys: dayArr)
            activitiesByDay.append(activities)

            print("DEBUG: date\(i)")
        }

        activitiesByWeek.append(ActivitiesByWeek(
            date: date,
            activitys: activitiesByDay))

        self.activityListWeekly.removeAll()
        self.activityListWeekly = activitiesByWeek
        self.getMaxAltitudeList(forWeek: true)

        self.barGraphModels.removeAll()
        self.gerMod()

    }

    private func getWeekdays(for date: Date) -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 2 // Start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: date)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }

        if let firstDate = week.first, let lastDate = week.last {
            let mydf = DateFormatter()
            mydf.dateStyle = .medium

            dateTitle = "\(mydf.string(from: firstDate)) - \(mydf.string(from: lastDate))"
        }

        return week
    }

    func getMonday(_ direction: graphDirection) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let components = calendar.dateComponents([.weekday], from: self.selectedDateForDraphs.today())

        var isMondayToday = false
        //                              var isSundayToday = false
        if components.weekday == 2 {
            isMondayToday = true
        }
        //                              else if components.weekday == 1 {
        //                                  isSundayToday = true
        //                              }

        var currentWeekMonday = isMondayToday ?
            selectedDateForDraphs.today() : selectedDateForDraphs.today().previous(.monday)

        switch direction {
        case .previous:
            currentWeekMonday = self.selectedDateForDraphs.today().previous(.monday)
        case .next:
            currentWeekMonday = self.selectedDateForDraphs.today().next(.monday)
        }


        selectedDateForDraphs = currentWeekMonday
        print("selectedDateForDraphs: \(selectedDateForDraphs) \(currentWeekMonday)")
        return currentWeekMonday
    }

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
                let endDate = activity.endDate
                let workoutActivityType = activity.workoutActivityType
                let distance = activity.totalDistance?.doubleValue(for: .meter())
                let metadata = activity.metadata
                let calories = activity.totalEnergyBurned?.doubleValue(for: .kilocalorie())


                let steps = (metadata?[MetadataKeys.stepsCount.rawValue] as? HKQuantity)?.doubleValue(for: .count())
                let elevationGain = (metadata?[MetadataKeys.elevationGain.rawValue]  as? HKQuantity)?.doubleValue(for: .meter())
                let reletiveAltitude = (metadata?[MetadataKeys.reletiveAltitude.rawValue]  as? HKQuantity)?.doubleValue(for: .meter())
                let maxAltitude = (metadata?[MetadataKeys.maxAltitude.rawValue] as? HKQuantity)?.doubleValue(for: .meter())

                let timeInterval = endDate.timeIntervalSince(startDate)
                let pace = Pace.calcPace(from: distance ?? 0, over: timeInterval)

                let title = metadata?[MetadataKeys.title.rawValue] as? String

                list.append(Activity(
                    start: startDate,
                    end: endDate,
                    activityType: localValue(workoutActivityType),
                    title: title,
                    hkValue: activity,
                    intervals: [],
                    calories: calories,
                    distance: distance ?? 0,
                    numberOfSteps: Int(steps ?? 0),
                    averagePace: pace,
                    elevationGain: elevationGain,
                    reletiveAltitude: reletiveAltitude,
                    maxAltitude: maxAltitude))
            }
            self.activityList = list

        }
    }

    func gerMod() {
        guard let arr =  activityListWeekly.first?.activitys else {
            return
        }
        for i in arr {
            self.barGraphModels.append(getProcent(arr: i.activitys ?? [Activity(start: Date(), end: Date(), activityType: .walking, intervals: [], distance: 0.1)], date: i.date))
        }

        getGoals(activitiesByWeek: activityListWeekly.first!)
    }

    func getProcent(arr: [Activity], date: Date) -> BarGraphModel {
        var distance = 0.0
        var typeArr:[ActivityType] = []
        var colors: [Color] = []

        for acrivity in arr {
            distance += acrivity.distance ?? 0
            typeArr.append(acrivity.activityType)
        }

        typeArr = typeArr.sorted { $0.rawValue < $1.rawValue }

        for i in typeArr {
            switch  i {
            case .walking:
                colors.append(ActivityType.walking.color())
            case .running:
                colors.append(ActivityType.running.color())
            case .hiking:
                colors.append(ActivityType.hiking.color())
            case .biking:
                colors.append(ActivityType.biking.color())
            }
        }

        if colors.count <= 1 {
            if let c = colors.first {
                colors.append(c)
            }
        }

        print("distance: \(CGFloat(distance))")
        print("colors count: \(colors.count)")
        return BarGraphModel(v: CGFloat(distance), c: colors, day: date.weekDay())
    }

    func getMaxAltitudeList(forWeek: Bool) {
        var list: [CGFloat] = []
        if forWeek {
            for activitiesByDay in activityListWeekly {
                if let activitiesByDaylist = activitiesByDay.activitys {
                    for day in activitiesByDaylist {
                        if let activitys = day.activitys {
                            for activitie in activitys {
                                if let maxAltitude = activitie.maxAltitude {
                                    list.append(CGFloat(maxAltitude))
                                }
                            }
                        }
                    }
                }
            }
        } else {
            for activitie in activityList {
                if let maxAltitude = activitie.maxAltitude {
                    list.append(CGFloat(maxAltitude))
                }
            }
        }

        maxAltitudeList.removeAll()
        maxAltitudeList = list
    }
}

extension Date {
    func weekDay() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "eeeee"
            let weekDay = dateFormatter.string(from: self)
            return weekDay
      }

    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }

    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    enum SearchDirection {
        case next
        case previous

        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}


extension Date {

    func today() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = calendar.timeZone
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 00
        components.minute = 00
        components.second = 00

        return calendar.date(from: components) ?? Date()
    }

    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }

    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }

    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {

        let dayName = weekDay.rawValue

        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

        var calendar = Calendar.current
        calendar.timeZone = calendar.timeZone

        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }

        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex

        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)

        return date!
    }

}

struct TimeHelper {
    static func getMidnight(forDate date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = calendar.timeZone
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 00
        components.minute = 00
        components.second = 00

        return calendar.date(from: components) ?? Date()
    }
}
