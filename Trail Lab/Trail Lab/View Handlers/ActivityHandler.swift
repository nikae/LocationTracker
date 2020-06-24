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

enum ActivityState {
    case active
    case inactive
    case paused
}


class ActivityHandler: ObservableObject {
    @Published var selectedActivityType: ActivityType = ActivityType(rawValue:Preferences.activityType) ?? .walking
    @Published var activityButtonTitle: String = "Start"
    @Published var activityState: ActivityState = .inactive
    @Published var activity: Activity?
    @Published var tempLocation: String = ""
    let locationManager = LocationManager()

    private (set) var startDate: Date!
    private (set) var endDate: Date!
    private var activityTimer: Timer?

    weak var mapViewDelegate: MapViewDelegate?

    func startActivity() {
        let startDate = Date()
        activityState = .active
        self.startDate = startDate
        activity = Activity(start: startDate,
                            activityType: selectedActivityType,
                            intervals: [])
        locationManager.startLocationUpdates(locationListener: { location in
            self.locationListener(location: location)
        }) { error in
            print(error)
        }
        startTimer()
    }

    func stopActivity() {
        activityState = .inactive
        stopTimer()
        let endDate = Date()
        addNewInterval(with: endDate)
        guard let activity = activity else {
            return
        }
        ActivityDataStore().save(activity: activity) { sucsess, error in
            if let error = error {
                print(error.localizedDescription)
            }

            print(sucsess)
        }
        locationManager.stopLocationUpdates { error in
            print(error)
        }
    }

     private func locationListener(location: CLLocation) {
        self.activity?.locations.append(location)
        tempLocation = "\(location)"
        if let locations = self.activity?.locations {
        mapViewDelegate?.updatePolyline(with:  locations)
        }
    }

    func pauseActivity() {
        activityState = .paused
    }

       private func startTimer() {
           guard activityTimer == nil else {print("Workout timer already started!"); return}
           activityTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
           RunLoop.main.add(activityTimer!, forMode: .default)
       }

       private func stopTimer() {
           guard activityTimer != nil else {print("Workout timer already stopped!"); return}
           activityTimer?.invalidate()
           activityTimer = nil
       }

     @objc private func timerTick() {
        let date = Date()
        addNewInterval(with: date)
        startDate = date
    }


    private func addNewInterval(with endDate: Date) {
        let interval = ActivityInterval(start: startDate, end: endDate)
        self.activity?.intervals.append(interval)
        print("Intervall Added: \(interval.duration.rounded())")
    }

    func authorizeHealthKit() {
        HealthPermisionsHandler.authorizeHealthKit { (authorized, error) in
            guard authorized else {

                //TODO: ASK User to go to settings
                let baseMessage = "HealthKit Authorization Failed"

                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }

                return
            }

            print("HealthKit Successfully Authorized.")
        }
    }
}

