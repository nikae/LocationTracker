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

protocol ActivityHandlerDelegate: class {
    func activitySaved()
}

class ActivityHandler: ObservableObject {
    @Published var selectedActivityType: ActivityType = ActivityType(rawValue:Preferences.activityType) ?? .walking
    @Published var activityButtonTitle: String = "Start"
    @Published var activityButtonColor: Color = Color(.secondaryLabel)
    @Published var activityState: ActivityState = .inactive
    @Published var activity: Activity?
    @Published var tempLocation: String = ""
    @Published var statsViewOffset: CGFloat = -300
    @Published var showLoadingAnimation: Bool = false

    let locationManager = LocationManager.shared
    let pedometerManager = PedometerManager()

    private (set) var startDate: Date!
    private (set) var endDate: Date!
    private var activityTimer: Timer?
    let audioManager = AudioManager.shared

    weak var mapViewDelegate: MapViewDelegate?
    weak var activityHandlerDelegate: ActivityHandlerDelegate?

    func animateStatsView(_ offset: CGFloat) {
        withAnimation(.interpolatingSpring(mass: 1.2,
                                           stiffness: 100,
                                           damping: 25,
                                           initialVelocity: 10)) {
                                            statsViewOffset = offset
        }
    }
    

    func startActivity() {
        UIApplication.shared.isIdleTimerDisabled = true
        let startDate = Date()
        activityState = .active
        self.startDate = startDate
        activity = Activity(start: startDate,
                            end: Date(),
                            activityType: selectedActivityType,
                            intervals: [])
        locationManager.startLocationUpdates(locationListener: { location in
            self.locationListener(location: location)
            if !(self.audioManager.player?.isPlaying ?? false) {
                self.audioManager.checkForLocation(location: location)
            }
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
        self.activity?.end = endDate

        if (activity?.duration ?? 0) > 60 {
            if let startLocation = self.activity?.locations.first {
                makeActivityTitle(startLocation) { placeMarkString in
                    if let placeMarkString = placeMarkString {
                        self.activity?.title = "\(placeMarkString) \(self.activity?.activityType.title() ?? "")"
                    }
                    self.saveActivity()
                }
            } else {
                saveActivity()
            }
        }

        locationManager.stopLocationUpdates { error in
            print(error)
        }
        pedometerManager.stopMonitoring()
        animateStatsView(-300)
        UIApplication.shared.isIdleTimerDisabled = false
    }

    func saveActivity() {
        guard let activity = activity else { return }
        showLoadingAnimation = true
        ActivityDataStore().save(activity: activity) { sucsess, error in
            self.showLoadingAnimation = false
           // self.activity?.locations.removeAll()
            self.activityHandlerDelegate?.activitySaved()

            if let error = error {
                print(error.localizedDescription)
            }
            print(sucsess)
        }
    }

    func makeActivityTitle(_ loc: CLLocation, completionHandler: @escaping ((String?) -> Void)) {
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemaks, error)->Void in
            if error != nil {
                print("Reverse geocoder filed with error: \(error!.localizedDescription)")
            }

            if let pm = placemaks?.first {

                if let areasOfInterest = pm.areasOfInterest?.first, let subLocality = pm.subLocality {
                    let randomBool = Bool.random()
                    completionHandler(randomBool ? areasOfInterest : subLocality)
                } else if let areasOfInterest = pm.areasOfInterest?.first {
                    completionHandler(areasOfInterest)
                } else if let subLocality = pm.subLocality {
                    completionHandler(subLocality)
                } else if let locality = pm.locality {
                    completionHandler(locality)
                } else if let administrativeArea = pm.administrativeArea {
                    completionHandler(administrativeArea)
                } else {
                    completionHandler(nil)
                }

            } else {
                completionHandler(nil)
            }
        })
    }

    private func locationListener(location: CLLocation) {
        let lastDistance = self.activity?.locations.last
        self.activity?.locations.append(location)
        self.activity?.altitude = location.altitude
        if (self.activity?.maxAltitude ?? 0) < location.altitude {
            self.activity?.maxAltitude = location.altitude 
        }

        if self.activity?.minAltitude == nil {
            self.activity?.minAltitude = location.altitude
        } else if (self.activity?.minAltitude ?? 0) > location.altitude {
            self.activity?.minAltitude = location.altitude
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

