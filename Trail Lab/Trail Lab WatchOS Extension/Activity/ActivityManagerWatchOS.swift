//
//  ActivityManagerWatchOS.swift
//  Trail Lab WatchOS Extension
//
//  Created by Nika Elashvili on 4/17/21.
//  Copyright © 2021 nika. All rights reserved.
//

import Foundation
import HealthKit
import Combine
import CoreLocation
import WatchKit



class ActivityManagerWatchOS: NSObject, ObservableObject {
    
    /// - Tag: DeclareSessionBuilder
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!
    var routeBuilder: HKWorkoutRouteBuilder!

    
    let locationManager = LocationManager.shared
    let pedometerManager = PedometerManager()
    var isWorkoutViableToSave = false
    
    let contentViewHandler = ContentViewHandler.shared
    
   
    
    #if DEBUG
    let minDuration: Int = 10
    #else
    let minDuration: Int = 60
    #endif
    
    /// - Tag: Publishers
    @Published var activity: Activity?
    @Published var elapsedSeconds: Int = 0
    
    // The app's workout state.
    var running: Bool = false
    
    /// - Tag: TimerSetup
    // The cancellable holds the timer publisher.
    var start: Date = Date()
    var cancellable: Cancellable?
    var accumulatedTime: Int = 0
        
    // Set up and start the timer.
    func setUpTimer() {
        start = Date()
        cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds = self.incrementElapsedTime()
            }
    }
    
    // Calculate the elapsed time.
    func incrementElapsedTime() -> Int {
        updateWorkoutViability()
        let runningTime: Int = Int(-1 * (self.start.timeIntervalSinceNow))
        return self.accumulatedTime + runningTime
    }
    
    private func updateWorkoutViability() {
        guard let type = activity?.activityType else { return }
        let wasViable = isWorkoutViableToSave
        isWorkoutViableToSave = isWorkoutViable()
        if !wasViable && isWorkoutViableToSave { // Save type as preferred when it becomes viable.
            Preferences.addNewPreferredWorkout(type: type.rawValue)
        }
    }
    private func isWorkoutViable() -> Bool { // Viable workouts are longer than 5 minutes
        return elapsedSeconds >= minDuration
    }

    
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        HealthPermissionsHandler.authorizeHealthKit { (authorized, error) in
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
            DispatchQueue.main.async {
                ContentViewHandler.shared.healthAuthorized = true
            }
            print("HealthKit Successfully Authorized.")
        }
    }
    
    func requestLocationAuthorization() {
        if !locationManager.hasPermission {
            locationManager.manager.requestWhenInUseAuthorization()
        }
    }
    
    // Provide the workout configuration.
    func workoutConfiguration(_ activityType: HKWorkoutActivityType) -> HKWorkoutConfiguration {
        /// - Tag: WorkoutConfiguration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = activityType
        configuration.locationType = .outdoor
        
        return configuration
    }
    
    // Start the workout.
    func startWorkout(_ activityType: HKWorkoutActivityType) {
        requestLocationAuthorization()
        // Start the timer.
        setUpTimer()
        
        WKInterfaceDevice.current().play(.start)
        DispatchQueue.main.async {
            self.running = true
            self.contentViewHandler.viewState = .inActivity
        }
        
        // Create the session and obtain the workout builder.
        /// - Tag: CreateWorkout
        activity = Activity(start: start,
                            end: Date(),
                            activityType: activityType.localValue(),
                            intervals: [])
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: self.workoutConfiguration(activityType))
            builder = session.associatedWorkoutBuilder()
            routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
        } catch {
            // Handle any exceptions.
            return
        }
        
        // Setup session and builder.
        session.delegate = self
        builder.delegate = self
        
        // Set the workout builder's data source.
        /// - Tag: SetDataSource
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: workoutConfiguration(activityType))
        
        // Start the workout session and begin data collection.
        /// - Tag: StartSession
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { (success, error) in
            // The workout has started.
        }
        
        locationManager.startLocationUpdates(locationListener: { location in
            self.locationListener(location: location)
        }) { error in
            self.requestLocationAuthorization()
            print(error)
        }
        
        self.beginPedometerDataCollection(start)
    }
    
    // MARK: - State Control
    func togglePause() {
        // If you have a timer, then the workout is in progress, so pause it.
        if running == true {
            self.pauseWorkout()
        } else {// if session.state == .paused { // Otherwise, resume the workout.
            resumeWorkout()
        }
    }
    
    func pauseWorkout() {
        // Pause the workout.
        session.pause()
        // Stop the timer.
        cancellable?.cancel()
        // Save the elapsed time.
        accumulatedTime = elapsedSeconds
        running = false
        WKInterfaceDevice.current().play(.stop)
    }
    
    func resumeWorkout() {
        // Resume the workout.
        session.resume()
        // Start the timer.
        setUpTimer()
        running = true
        WKInterfaceDevice.current().play(.start)
    }
    
    func endWorkout() {
        // End the workout session.
        session.end()
        cancellable?.cancel()
        locationManager.stopLocationUpdates { error in
            print(error)
        }
        pedometerManager.stopMonitoring()
        WKInterfaceDevice.current().play(.stop)
    }
    
    func showSummery() {
        DispatchQueue.main.async {
            self.running = false
            self.contentViewHandler.viewState = .summary
        }
    }
    
    func resetWorkout() {
        // Reset the published values.
        DispatchQueue.main.async {
            self.activity = nil
            self.elapsedSeconds = 0
            self.running = false
            self.contentViewHandler.viewState = .beforeActivity
        }
    }
    
    // MARK: - Update the UI
    // Update the published values.
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                /// - Tag: SetLabel
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                let roundedValue = Double( round( 1 * value! ) / 1 )
                self.activity?.hrSamples?.append(roundedValue)
                self.activity?.currentHR = roundedValue
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                let value = statistics.sumQuantity()?.doubleValue(for: energyUnit)
                self.activity?.calories = Double( round( 1 * value! ) / 1 )
                return
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                let value = statistics.sumQuantity()?.doubleValue(for: meterUnit)
                let roundedValue = Double( round( 1 * value! ) / 1 )
                self.activity?.distance = roundedValue
                return
            case HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                let value = statistics.sumQuantity()?.doubleValue(for: meterUnit)
                let roundedValue = Double( round( 1 * value! ) / 1 )
                self.activity?.distance =  roundedValue
                return
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                let count = HKUnit.count()
                let value = statistics.sumQuantity()?.doubleValue(for: count)
                self.activity?.numberOfSteps = Int(value ?? 0)
                return
            default:
                return
            }
        }
    }
}

extension ActivityManagerWatchOS {
    func makeMetadata() -> [String: Any] {
        var metadata: [String: Any] = [:]
        let steps = HKQuantity(unit: .count(), doubleValue: Double(activity?.numberOfSteps ?? 0))
        let elevationGain = HKQuantity(unit: .meter(), doubleValue: activity?.elevationGain ?? 0)
        let reletiveAltitude = HKQuantity(unit: .meter(), doubleValue: activity?.reletiveAltitude ?? 0)
        let maxAltitude = HKQuantity(unit: .meter(), doubleValue: activity?.maxAltitude ?? 0)
        let minAltitude = HKQuantity(unit: .meter(), doubleValue: activity?.minAltitude ?? 0)
        
        metadata[MetadataKeys.stepsCount.rawValue] = steps
        metadata[MetadataKeys.elevationGain.rawValue] = elevationGain
        metadata[MetadataKeys.reletiveAltitude.rawValue] = reletiveAltitude
        metadata[MetadataKeys.maxAltitude.rawValue] = maxAltitude
        metadata[MetadataKeys.minAltitude.rawValue] = minAltitude
        
        return metadata
    }
    
    
    private func discardActivity() {
        builder.discardWorkout()
        DispatchQueue.main.async {
            self.resetWorkout()
            WKInterfaceDevice.current().play(.failure)
        }
        
    }
    
    func saveActivity() {
        
        var metadata: [String: Any] = makeMetadata()
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "Save_Activity")
        
        queue.async {
            group.enter()
            if let startLocation = self.activity?.locations.first {
                ActivityTitleHandler().makeActivityTitle(startLocation) { placeMarkString in
                    if let placeMarkString = placeMarkString {
                        self.activity?.title = "\(placeMarkString) \(self.activity?.activityType.title() ?? "")"
                        if let title = self.activity?.title {
                            metadata[MetadataKeys.title.rawValue] = title
                        }
                        print("title ::: \(self.activity?.title ?? "No title")")
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
            group.wait()
        }
        
        queue.async {
            group.enter()
            self.builder.addMetadata(metadata) { success, error in
                print(success)
                group.leave()
            }
            group.wait()
        }
        
        queue.async {
            group.enter()
            self.builder.endCollection(withEnd: Date()) { (success, error) in
                group.leave()
            }
            group.wait()
        }
        
        queue.async {
            group.enter()
            
            self.builder.finishWorkout { (workout, error) in
                // Optionally display a workout summary to the user.
                // Create, save, and associate the route with the provided workout.

                guard let workout = workout else {
                    DispatchQueue.main.async {
                        self.showSummery()
                        WKInterfaceDevice.current().play(.failure)
                    }
                    return
                }
                
                self.routeBuilder.finishRoute(with: workout, metadata: [:]) { (newRoute, error) in
                    DispatchQueue.main.async {
                        self.showSummery()
                    }
                    
                    guard newRoute != nil else {
                        // Handle any errors here.
                        print("\(String(describing: error?.localizedDescription))")
                        WKInterfaceDevice.current().play(.failure)
                        return
                    }
                    
                    WKInterfaceDevice.current().play(.success)
                    group.leave()
                    // Optional: Do something with the route here.
                   
                }
            }
        }
            
        group.notify(queue: .main) {
            print("DispatchGroup Done")
        }
    }
}



// MARK: - HKWorkoutSessionDelegate
extension ActivityManagerWatchOS: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        // Wait for the session to transition states before ending the builder.
        /// - Tag: SaveWorkout
        if toState == .ended {
            print("The workout has now ended.")
            if isWorkoutViableToSave {
                saveActivity()
            } else {
                discardActivity()
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("HKWorkoutSession didFailWithError \(error)")
    }
}



// MARK: - HKLiveWorkoutBuilderDelegate
extension ActivityManagerWatchOS: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) { }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            let statistics = workoutBuilder.statistics(for: quantityType)
            updateForStatistics(statistics)
        }
    }
}

// MARK: Location Listener
extension ActivityManagerWatchOS {
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
        
        guard let locations = self.activity?.locations, !locations.isEmpty else {
            return
        }
        
        routeBuilder.insertRouteData(locations) { (success, error) in
            if !success {
                print(error?.localizedDescription ?? "routeBuilder insertRouteData Error")
            }
        }
    }
}

// MARK: Pedometer Manager
extension ActivityManagerWatchOS {
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


