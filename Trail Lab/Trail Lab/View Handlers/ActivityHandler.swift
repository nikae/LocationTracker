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
    @Published var statsViewOffset: CGFloat = -300
    let locationManager = LocationManager.shared
    let pedometerManager = PedometerManager()

    private (set) var startDate: Date!
    private (set) var endDate: Date!
    private var activityTimer: Timer?

    weak var mapViewDelegate: MapViewDelegate?

    func animateStatsView(_ offset: CGFloat) {
        withAnimation(.interpolatingSpring(mass: 1.2,
        stiffness: 100,
        damping: 25,
        initialVelocity: 10)) {
            statsViewOffset = offset
        }
    }

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
        beginPedometerDataCollection(startDate)
        animateStatsView(60)
    }

    func stopActivity() {
        activityState = .inactive
        stopTimer()
        let endDate = Date()
        addNewInterval(with: endDate)
        guard let activity = activity else {
            return
        }
        if activity.duration > 60 {
        ActivityDataStore().save(activity: activity) { sucsess, error in
            if let error = error {
                print(error.localizedDescription)
            }

            print(sucsess)
        }
        }
        locationManager.stopLocationUpdates { error in
            print(error)
        }
        pedometerManager.stopMonitoring()
        animateStatsView(-300)
    }

     private func locationListener(location: CLLocation) {
        let lastDistance = self.activity?.locations.last
        self.activity?.locations.append(location)
        self.activity?.altitude = location.altitude
        if (self.activity?.maxAltitude ?? 0) < location.altitude {
            self.activity?.maxAltitude = location.altitude 
        }

        if activity?.activityType.hkValue() == .cycling {
            if let lastDistance = lastDistance {
                if self.activity?.distance == nil {
                    self.activity?.distance = location.distance(from: lastDistance)
                } else {
                    self.activity?.distance! += location.distance(from: lastDistance)
                }
            }

            if location.speedAccuracy != -1 {
                self.activity?.speedCurrent = location.speed
            }
        }

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

    private func beginPedometerDataCollection(_ startDate: Date) {
        pedometerManager.resetPedometer()
        pedometerManager.pedometerListener = { steps , distance, averagePace, pace, floorsAscended, floorsDscended, cadence in
            DispatchQueue.main.async {
                if self.activity?.activityType.hkValue() != .cycling {
                    self.activity?.numberOfSteps = steps
                self.activity?.distance = distance
                self.activity?.averagePace = averagePace
                self.activity?.pace = pace
                }
                self.activity?.floorsAscended = floorsAscended
                self.activity?.floorsDscended = floorsDscended
                self.activity?.cadence = cadence
            }
        }

        pedometerManager.altimeterListener = { elevationGain, reletiveAltitude in
            self.activity?.elevationGain = elevationGain
            self.activity?.reletiveAltitude = reletiveAltitude
        }

        pedometerManager.startMonitoring(startDate)
    }
}

