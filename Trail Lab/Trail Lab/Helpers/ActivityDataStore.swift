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

struct Activity {
    let activityType: ActivityType
    var start: Date
    var end: Date {
        return intervals.last?.end ?? Date()
    }
    var intervals: [ActivityInterval]
    var locations: [CLLocation] = []

    var numberOfSteps: Int?
    var distance: Double?
    var pace: Double?
    var speed: Double?
    var averagePace: Double?
    var floorsAscended: Int?
    var floorsDscended: Int?
    var cadence: Double?

    init(start: Date,
         activityType: ActivityType,
         intervals: [ActivityInterval]) {
        self.start = start
        self.activityType = activityType
        self.intervals = intervals
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
    let workoutConfiguration = HKWorkoutConfiguration()

    override init() {
        super.init()
        self.routeBuilder = HKWorkoutRouteBuilder(healthStore: self.healthStore, device: .local())
    }

    func save(
        activity: Activity,
        completion: @escaping ((Bool, Error?) -> Swift.Void)) {

        workoutConfiguration.activityType = activity.activityType.hkValue()
        workoutConfiguration.locationType = .outdoor

        addLocationTotheBuilder(location: activity.locations)

        let builder = HKWorkoutBuilder(healthStore: healthStore,
                                       configuration: workoutConfiguration,
                                       device: .local())

        builder.beginCollection(withStart: activity.start) { (success, error) in
            guard success else {
                completion(false, error)
                return
            }
        }

        let samples = self.samples(for: activity)

        builder.add(samples) { (success, error) in
            guard success else {
                completion(false, error)
                return
            }

            builder.endCollection(withEnd: activity.end) { (success, error) in
                guard success else {
                    completion(false, error)

                    return
                }

                builder.finishWorkout { (workout, error) in
                    let success = error == nil
                    completion(success, error)
                    if let workout = workout {
                        self.saveToRouteBuilder(workout: workout )
                    }
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

    class func loadPrancerciseWorkouts(completion:
        @escaping ([HKWorkout]?, Error?) -> Void) {
        //1. Get all workouts with the "Other" activity type.
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .other)

        //2. Get all workouts that only came from this app.
        let sourcePredicate = HKQuery.predicateForObjects(from: .default())

        //3. Combine the predicates into a single predicate.
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:
            [workoutPredicate, sourcePredicate])

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)

        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: compound,
            limit: 0,
            sortDescriptors: [sortDescriptor]) { query, samples, error in
                DispatchQueue.main.async {
                    guard let samples = samples as? [HKWorkout],error == nil else {
                        completion(nil, error)
                        return
                    }

                    completion(samples, nil)
                }
        }

        HKHealthStore().execute(query)
    }

    func addLocationTotheBuilder(location: [CLLocation]) {

        self.routeBuilder?.insertRouteData(location, completion: { (success, error) in
            guard error == nil else {
                print("ERROR: Error in inserting locations to route builder: \(error!.localizedDescription)")

                return
            }
            print("DEBUG: successfully inserted the route data \(success)")

        })
    }

    func saveToRouteBuilder(workout: HKWorkout) {
        self.routeBuilder?.finishRoute(with: workout, metadata: nil, completion: { (route, error) in
            if route == nil{
                print("ERROR: finishing route failed with error: \(String(describing: error?.localizedDescription))")
            }
            print("DEBUG: route successfully finished: \(String(describing: route))")
        })
    }
}
