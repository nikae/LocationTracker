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
import UIKit

struct Activity {
    let id = UUID()
    let activityType: ActivityType
    var start: Date
    var hkValue: HKWorkout?
    var title: String?
    var end: Date
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

    var calories: Double?

    init(start: Date,
         end: Date,
         activityType: ActivityType,
         title: String? = nil,
         hkValue: HKWorkout? = nil,
         intervals: [ActivityInterval],
         calories: Double? = nil,
         distance: Meter? = nil,
         numberOfSteps: Int? = nil,
         averagePace: SecondsPerMeter? = nil,
         elevationGain: Meter? = nil,
         reletiveAltitude: Meter? = nil,
         maxAltitude: Meter?  = nil) {
        self.start = start
        self.end = end
        self.hkValue = hkValue
        self.activityType = activityType
        self.title = title
        self.intervals = intervals
        self.distance = distance
        self.numberOfSteps = numberOfSteps
        self.averagePace = averagePace
        self.elevationGain = elevationGain
        self.reletiveAltitude = reletiveAltitude
        self.maxAltitude = maxAltitude
        self.calories = calories
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

    var speed: MetersPerSecond? {
        if let distance = distance, duration > 0 {
            return distance / duration
        } else {
            return nil
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

enum MetadataKeys: String {
    case stepsCount = "Steps Count"
    case elevationGain = "Elevation Gain"
    case reletiveAltitude = "Reletive Altitude"
    case maxAltitude = "Max Altitude"
    case title = "Title"
}

class ActivityDataStore: NSObject {

    var routeBuilder: HKWorkoutRouteBuilder!
    let healthStore = HKHealthStore()

    override init() {
        super.init()
        self.routeBuilder = HKWorkoutRouteBuilder(healthStore: self.healthStore, device: .local())
    }

    func save(activity: Activity, completion: @escaping (_ succsess: Bool, _ error: Error?) -> Void) {

        var metadata: [String: Any] = [:]
        let totalDistance = HKQuantity(unit: .meter(), doubleValue: activity.distance ?? 0)
        let steps = HKQuantity(unit: .count(), doubleValue: Double(activity.numberOfSteps ?? 0))
        let totalEnergyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: activity.totalEnergyBurned)
        let elevationGain = HKQuantity(unit: .meter(), doubleValue: activity.elevationGain ?? 0)
        let reletiveAltitude = HKQuantity(unit: .meter(), doubleValue: activity.reletiveAltitude ?? 0)
        let maxAltitude = HKQuantity(unit: .meter(), doubleValue: activity.maxAltitude ?? 0)

        metadata[MetadataKeys.stepsCount.rawValue] = steps
        metadata[MetadataKeys.elevationGain.rawValue] = elevationGain
        metadata[MetadataKeys.reletiveAltitude.rawValue] = reletiveAltitude
        metadata[MetadataKeys.maxAltitude.rawValue] = maxAltitude

        if let title = activity.title {
            metadata[MetadataKeys.title.rawValue] = title
        }

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

        let group = DispatchGroup()
        group.enter()

        //ImplementErrorHendling

        healthStore.save(healthkitWorkout) { (success, error) in
            print("DispatchGroup \(1.1)")
            if let error = error {
                postDebugErrorNotification(error.localizedDescription)
            }
            group.leave()
            print("DispatchGroup \(1.2)")
        }

        group.enter()
        self.addLocationTotheBuilder(healthkitWorkout, location: activity.locations) { success, error in
            print("DispatchGroup \(2.1)")
            if let error = error {
                postDebugErrorNotification(error.localizedDescription)
            }

            group.leave()
            print("DispatchGroup \(2.2)")
        }

        group.enter()
            self.healthStore.add(mySamples, to: healthkitWorkout) { (success, error) in
                print("DispatchGroup \(3.1)")
                if let error = error {
                    postDebugErrorNotification(error.localizedDescription)
                }

                group.leave()
                print("DispatchGroup \(3.2)")
        }

        group.notify(queue: .main) {
             print("DispatchGroup Done")
            completion(true, nil)
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
    static func loadPrancerciseWorkouts(completion:
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



    func getLocations(_ workout: HKWorkout, completion: @escaping (_ path: [CLLocation]?) -> Void) {

        var  path: [CLLocation] = []

        let runningObjectQuery = HKQuery.predicateForObjects(from: workout)

        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in

            guard error == nil else {
                // Handle any errors here.
                fatalError("The initial query failed.")
            }

            guard let samples = samples else {
                print("No samples")
                return
            }
            guard samples.count > 0 else {
                print("No samples")
                return
            }

            guard let route = samples.first as? HKWorkoutRoute else {
                fatalError("No samples")
            }

            // Create the route query.
                   let query = HKWorkoutRouteQuery(route: route) { (query, locationsOrNill, done, errorOrNil) in

                       // This block may be called multiple times.

                    if let error = errorOrNil {
                        postDebugErrorNotification(error.localizedDescription)
                        return
                    }

                       guard let locations = locationsOrNill else {
                           fatalError("*** Invalid State: This can only fail if there was an error. ***")
                       }


                       // Do something with this batch of location data.
                    print("DDDDDD: \(locations.count)")
                    path.append(contentsOf: locations)
                       if done {
                        print("DDDDDD: 2\(locations.count)")
                        completion(path)
                           // The query returned all the location data associated with the route.
                           // Do something with the complete data set.
                       }

                       // You can stop the query by calling:
                       // store.stop(query)

                   }
            self.healthStore.execute(query)
        }

        routeQuery.updateHandler = { (query, samples, deleted, anchor, error) in

            guard error == nil else {
                // Handle any errors here.
                fatalError("The update failed.")
            }

            // Process updates or additions here.
        }

        healthStore.execute(routeQuery)



    }
    

    func addLocationTotheBuilder(_ workout: HKWorkout, location: [CLLocation], completion: @escaping (_ succsess: Bool, _ error: Error?) -> Void) {

        self.routeBuilder?.insertRouteData(location, completion: { (success, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "Error insertRouteData")
                if let error = error {
                    postDebugErrorNotification(error.localizedDescription)
                }
                return
            }

            self.saveToRouteBuilder(workout: workout) { success, error in
                completion(success, error)
            }
        })
    }

    func saveToRouteBuilder(workout: HKWorkout, completion: @escaping (_ succsess: Bool, _ error: Error?) -> Void) {
        self.routeBuilder?.finishRoute(with: workout, metadata: nil, completion: { (route, error) in

            if route == nil {
                print(error?.localizedDescription ?? "route == nil")
                completion(false, error)
            } else {
                completion(true, nil)
            }
        })
    }

    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    class func getActivityList(completion: @escaping ([Activity]) -> Void) {

        loadPrancerciseWorkouts { activityList, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "No activity")
                postDebugErrorNotification(error?.localizedDescription ?? "No activity")
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

            let sortedList = list.sorted { $0.start > $1.start}
            completion(sortedList)
        }
    }

}
