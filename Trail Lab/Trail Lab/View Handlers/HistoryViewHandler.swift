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

class HistoryViewHandler: ObservableObject {

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
        distanceGoal: Preferences.distanceGoal,
        distanceProgress: 0,
        distanceFormmated: "--",
        time: 0,
        timeGoal: Preferences.timeGoal,
        timeProgress: 0,
        timeFormmated: "--")
    @Published var newWorkoutLoadingIsDone: Bool = false

    @Published var errorMessage: String = "Error"
    @Published var showAlert: Bool = false
    @Published var showDistanceGoal: Bool = false
    @Published var showDurationGoal: Bool = false

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(echoToggled), name: .errorWithMessage, object: nil)
    }

    @objc func echoToggled(notification: Notification){
        if let state = notification.object as? String{
            DispatchQueue.main.async {
                self.errorMessage = state
                if !self.showAlert {
                    self.showAlert.toggle()
                }
            }
        }
    }
    
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

        let distanceFormmated = "\(totalDistance.formatDistane()) / \n\(Preferences.distanceGoal.formatDistane())"
        let timeFormmated = "\(totalDuration.format(using: [.hour, .minute]) ?? "--") / \n\(Preferences.timeGoal.format(using: [.hour, .minute]) ?? "--")"

        self.weeklyGoal = WeeklyGoal(
            distance: totalDistance,
            distanceGoal: Preferences.distanceGoal,
            distanceProgress: Float(totalDistance / Preferences.distanceGoal),
            distanceFormmated:distanceFormmated,
            time: totalDuration,
            timeGoal: Preferences.timeGoal,
            timeProgress: Float(totalDuration / Preferences.timeGoal),
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

        self.gerMod()

    }

    private func getWeekdays(for date: Date) -> [Date] {
        let week = date.week()
        dateTitle = week.title
        return week.week
    }

    func getMonday(_ direction: graphDirection, for date: Date) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let components = calendar.dateComponents([.weekday], from: date.today())

        var isMondayToday = false
        if components.weekday == 2 {
            isMondayToday = true
        }

        var currentWeekMonday = isMondayToday ?
            date.today() : date.today().previous(.monday)

        switch direction {
        case .current:
            break
        case .previous:
            currentWeekMonday = date.today().previous(.monday)
        case .next:
            currentWeekMonday = date.today().next(.monday)
        }

        selectedDateForDraphs = currentWeekMonday
        print("selectedDateForDraphs: \(selectedDateForDraphs) \(currentWeekMonday)")
        return currentWeekMonday
    }

    func getActivityList(completion: @escaping (Bool) -> Void) {
        ActivityDataStore.getActivityList { activityListin in
            self.activityList = activityListin
            completion(true)
        }
    }

    func gerMod() {
        guard let arr =  activityListWeekly.first?.activitys else {
            return
        }

        self.barGraphModels.removeAll()
        
        for i in arr {
            self.barGraphModels.append(getProcent(arr: i.activitys ?? [Activity(start: Date(), end: Date(), activityType: .walking, intervals: [], distance: 0.1)], date: i.date))
        }

        getGoals(activitiesByWeek: activityListWeekly.first!)
    }

    func getDistanceProcentFor(arr: [Activity]) -> (CGFloat, CGFloat, CGFloat, CGFloat) {

        var walkProcent: CGFloat = 0
        var runProcent: CGFloat = 0
        var hikeProcent: CGFloat = 0
        var bikeProcent: CGFloat = 0

        var walkDistance: Double = 0
        var runDistance: Double = 0
        var hikeDistance: Double = 0
        var bikeDistance: Double = 0

        var totalDouble: Double { return walkDistance + runDistance + hikeDistance + bikeDistance }

        for i in arr {
            switch i.activityType {
            case .walking:
                walkDistance += i.distance ?? 0
            case .running:
                runDistance += i.distance ?? 0
            case .hiking:
                hikeDistance += i.distance ?? 0
            case .biking:
                bikeDistance += i.distance ?? 0

            }
        }

        walkProcent = walkDistance > 0 && totalDouble > 0 ?
            CGFloat(walkDistance / totalDouble) : 0
        runProcent = runDistance > 0 && totalDouble > 0 ?
            CGFloat(runDistance / totalDouble) : 0
        hikeProcent = hikeDistance > 0 && totalDouble > 0 ?
            CGFloat(hikeDistance / totalDouble) : 0
        bikeProcent = bikeDistance > 0 && totalDouble > 0 ?
            CGFloat(bikeDistance / totalDouble) : 0

        return (walkProcent , runProcent, hikeProcent, bikeProcent)
    }
    

    func getProcent(arr: [Activity], date: Date) -> BarGraphModel {
        var distance = 0.0

        for acrivity in arr {
            distance += acrivity.distance ?? 0
        }

        let (walkProcent, runProcent, hikeProcent, bikeProcent) = getDistanceProcentFor(arr: arr)


        var gradient = Gradient(stops: [])

        if walkProcent > 0 {
            gradient.stops.append(.init(color: ActivityType.walking.color(), location: 0))
        }
        if runProcent > 0 {
            gradient.stops.append(.init(color: ActivityType.running.color(), location: walkProcent))
        }
        if hikeProcent > 0 {
            gradient.stops.append(.init(
                color: ActivityType.hiking.color(),
                location: walkProcent + runProcent))
        }
        if bikeProcent > 0 {
            gradient.stops.append(.init(color: ActivityType.biking.color(), location: walkProcent + runProcent + hikeProcent))
        }

        if gradient.stops.count == 1 {
            if let newStep = gradient.stops.first {
                gradient.stops.append(newStep)
            }
        }

        return BarGraphModel(v: CGFloat(distance), c: gradient, day: date.weekDay())
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
extension HistoryViewHandler: ActivityHandlerDelegate {
    func activitySaved() {
        self.getActivityList { _ in
            if let activitie = self.activityList.first {
                self.selectedActivity = activitie
                self.newWorkoutLoadingIsDone.toggle()
            }
        }
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
