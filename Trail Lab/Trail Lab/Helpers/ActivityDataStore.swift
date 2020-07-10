//
//  ActivityDataStore.swift
//  Trail Lab
//
//  Created by Nika on 6/18/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import HealthKit
import CoreLocation
import UserNotifications

struct Activity {
    let id = UUID()
    let activityType: ActivityType
    var start: Date
    var end: Date {
        return intervals.last?.end ?? Date()
    }
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

    var speed: MetersPerSecond? {
        if let distance = distance, duration > 0 {
            return distance / duration
        } else {
            return nil
        }
    }

    init(start: Date,
         activityType: ActivityType,
         intervals: [ActivityInterval],
         distance: Meter? = nil) {
        self.start = start
        self.activityType = activityType
        self.intervals = intervals
        self.distance = distance
    }

    var totalEnergyBurned: Double {
        return intervals.reduce(0) { (result, interval) in
            result + interval.totalEnergyBurned
        }
    }

    var duration: TimeInterval {
        return intervals.reduce(0) { (result, interval) in
            result + interval.duration
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

class ActivityDataStore: NSObject {

    var routeBuilder: HKWorkoutRouteBuilder!
    let healthStore = HKHealthStore()

    override init() {
        super.init()
        self.routeBuilder = HKWorkoutRouteBuilder(healthStore: self.healthStore, device: .local())
    }

    func save(
        activity: Activity,
        completion: @escaping ((Bool, Error?) -> Swift.Void)) {

        var metadata: [String: Any] = [:]
        let totalDistance = HKQuantity(unit: .meter(), doubleValue: activity.distance ?? 0)
        let steps = HKQuantity(unit: .count(), doubleValue: Double(activity.numberOfSteps ?? 0))
        let totalEnergyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: activity.totalEnergyBurned)

        metadata["Steps Count"] = steps

        let healthkitWorkout = HKWorkout(
            activityType: activity.activityType.hkValue(),
            start: activity.start,
            end: activity.end,
            duration: activity.duration,
            totalEnergyBurned: totalEnergyBurned,
            totalDistance: totalDistance,
            device: .local(),
            metadata: metadata)


        var mySamples: [HKSample] = []
        let activeEnergyBurned = self.samples(for: activity)
        let distanceSamples = self.distanceSamples(for: activity)
        mySamples.append(contentsOf: activeEnergyBurned)
        mySamples.append(contentsOf: distanceSamples)

        healthStore.save(healthkitWorkout) { (success, error) in
            guard success else {
                completion(false, error)
                return
            }

            self.addLocationTotheBuilder(healthkitWorkout, location: activity.locations)

            self.healthStore.add(mySamples, to: healthkitWorkout) { (success, error) in
                guard success else {
                    completion(false, error)
                    return
                }
            }
        }
    }

    private func samples(for activity: Activity) -> [HKSample] {
        //1. Verify that the energy quantity type is still available to HealthKit.
        guard let energyQuantityType = HKSampleType.quantityType(
            forIdentifier: .activeEnergyBurned) else {
                fatalError("*** Energy Burned Type Not Available ***")
        }

        //2. Create a sample for each PrancerciseWorkoutInterval
        let samples: [HKSample] = activity.intervals.map { interval in
            let calorieQuantity = HKQuantity(
                unit: .kilocalorie(),
                doubleValue: interval.totalEnergyBurned)

            return HKCumulativeQuantitySample(
                type: energyQuantityType,
                quantity: calorieQuantity,
                start: interval.start,
                end: interval.end)
        }

        return samples
    }

    private func distanceSamples(for activity: Activity) -> [HKSample] {
        var distanceWalkingRunning: HKQuantityTypeIdentifier {
            return activity.activityType.hkValue() == .cycling ? .distanceCycling : .distanceWalkingRunning
        }
        //1. Verify that the energy quantity type is still available to HealthKit.
        guard let energyQuantityType = HKSampleType.quantityType(
            forIdentifier: distanceWalkingRunning) else {
                fatalError("*** Energy Burned Type Not Available ***")
        }

        //2. Create a sample for each PrancerciseWorkoutInterval
        let calorieQuantity = HKQuantity(
            unit: .meter(),
            doubleValue: activity.distance ?? 0)

        let samples: [HKSample] = [HKCumulativeQuantitySample(
            type: energyQuantityType,
            quantity: calorieQuantity,
            start: activity.start,
            end: activity.end)]


        return samples
    }

    //MARK: get workouts ftom health
    class func loadPrancerciseWorkouts(completion:
        @escaping ([HKWorkout]?, Error?) -> Void) {
        //1. Get all workouts with the "Other" activity type.
        //        let workoutPredicateWalking = HKQuery.predicateForWorkouts(with: .walking)
        //        let workoutPredicateRunning = HKQuery.predicateForWorkouts(with: .running)
        //        let workoutPredicateHiking = HKQuery.predicateForWorkouts(with: .hiking)
        //let workoutPredicateCycling = HKQuery.predicateForWorkouts(with: .hiking)

        //2. Get all workouts that only came from this app.
        let sourcePredicate = HKQuery.predicateForObjects(from: .default())

        //3. Combine the predicates into a single predicate.
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:
            [sourcePredicate])

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: true)

        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: compound,
            limit: 0,
            sortDescriptors: [sortDescriptor]) { query, samples, error in
                DispatchQueue.main.async {
                    guard let samples = samples as? [HKWorkout], error == nil else {
                        completion(nil, error)
                        return
                    }

                    completion(samples, nil)
                }
        }

        HKHealthStore().execute(query)
    }

    func addLocationTotheBuilder(_ workout: HKWorkout, location: [CLLocation]) {

        self.routeBuilder?.insertRouteData(location, completion: { (success, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "Error insertRouteData")
                return
            }

            self.saveToRouteBuilder(workout: workout)
        })
    }

    func saveToRouteBuilder(workout: HKWorkout) {
        self.routeBuilder?.finishRoute(with: workout, metadata: nil, completion: { (route, error) in
            if route == nil {
                print(error?.localizedDescription ?? "route == nil")
            }
        })
    }
}
