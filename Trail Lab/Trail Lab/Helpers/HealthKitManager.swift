////
////  HealthKitManager.swift
////  Trail Lab
////
////  Created by Nika on 7/22/20.
////  Copyright © 2020 nilka. All rights reserved.
////
//
//import Foundation
//import HealthKit
//
//
//class HealthKitManager {
//
//    var healthStore = HKHealthStore()
//
//    func requestAuthorization() {
//        guard HKHealthStore.isHealthDataAvailable() else{
//            print("This device doesn't have HealthKit")
//            return
//        }
//
//        let workoutType = HKQuantityType.workoutType()
//        let workoutRouteType = HKSeriesType.workoutRoute()
//
//        healthStore.requestAuthorization(toShare: [workoutType, workoutRouteType], read: [workoutType, workoutRouteType]) { (success, error) in
//            if success{
//                print("DEBUG: HealthKit authorization success")
//            } else{
//                print("ERROR: HealthKit authorization failed with \(String(describing: error?.localizedDescription))")
//            }
//
//            if success{
//                self.setUpObservingHealthStoreForChanges(type: HKQuantityType.workoutType())
//            }
//        }
//    }
//
//
////    func getWorkoutDataFromHealth(startDate: Date, endDate: Date, completion: @escaping (_ workouts: [HKWorkout]?) -> Void){
////        let sampleType = HKObjectType.workoutType()
////        let startDate =  startDate as NSDate
////        let endDate = endDate as NSDate
////
////        var workouts: [HKWorkout] = []
////        let predicate = HKQuery.predicateForSamples(
////            withStart: startDate as Date,
////            end: endDate as Date,
////            options: .strictStartDate)
////        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
////        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 10, sortDescriptors: [sortDescriptor]) { (query, results, error) in
////
////            if error == nil {
////
////
////                if let results = results {
////                    for result in results {
////                        if let workout = result as? HKWorkout {
////                            workouts.append(workout)
////                        }
////                    }
////                    completion(workouts)
////                }
////                else {
////                    // No results were returned, check the error
////                    completion(nil)
////                }
////            } else {
////                completion(nil)
////                print("error \(error!)")
////            }
////        }
////
////        healthStore.execute(query)
////
////    }
//
//    func setUpObservingHealthStoreForChanges(type: HKSampleType){
//        print("DEBUG: func setUpObservingHealthStoreForChanges called")
//
//        let observerQuery = HKObserverQuery(sampleType: type, predicate: nil) { (OQuery, completionHandler, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//            print("DEBUG: ObserverQuery executed")
//
//            completionHandler()
//            self.setUpAnchoredObjectQuery(type: type)
//        }
//        healthStore.execute(observerQuery)
//        healthStore.enableBackgroundDelivery(for: type, frequency: .immediate) { (success, error) in
//            print("DEBUG: enableBackgroundDelivery called: \(success) with error: \(String(describing: error?.localizedDescription))")
//        }
//    }
//
//    func setUpAnchoredObjectQuery(type: HKSampleType){
//        print("DEBUG: func setUpAnchoredObjectQuery called")
//        var anchor = HKQueryAnchor.init(fromValue: 0)
//        if let previousAnchor = Preferences.newAnchor {
//            do {
//                print("DEBUG: Anchored object \(anchor)")
//                anchor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(previousAnchor) as! HKQueryAnchor
//            }
//            catch{
//                print("couldn't archive the anchor")
//            }
//        }
//
//        let anchoredQuery = HKAnchoredObjectQuery(type: type, predicate: nil, anchor: anchor, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, newAnchor, error) in
//
//            print("DEBUG: HKAnchoredObjectQuery executed")
//            guard let samples = samples, let deletedObjects = deletedObjects else{
//                print("DEBUG: No new changes")
//                return
//            }
//
//            anchor = newAnchor!
//
//            do{
//                let data : Data = try NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any, requiringSecureCoding: true)
//                Preferences.newAnchor = data
//            }
//            catch{
//                print("[ERROR] in retrieving anchor")
//            }
//
//            if samples.count > 0{
//
//                if Preferences.newWorkoutSample != nil{
//
//                    if Preferences.newWorkoutSample != samples[0].uuid.uuidString{
//
//                        Preferences.newWorkoutSample = samples[0].uuid.uuidString
//                        self.checkSourceAndScheduleNotifications(workout: samples[0] as! HKWorkout)
//
//                    }
//                    else{
//                        print("[DEBUG] notification is already triggered for this new workout sample")
//                    }
//
//                }
//                else{
//                    Preferences.newWorkoutSample = samples[0].uuid.uuidString
//                    self.checkSourceAndScheduleNotifications(workout: samples[0] as! HKWorkout)
//
//                }
//
//            }
//
//            for sample in samples{
//
//                print("DEBUG: New samples are \(sample.uuid)")
//            }
//
//            for deleted in deletedObjects{
//                print("DEBUG: Recently deleted samples are \(deleted)")
//
//            }
//            print("Anchor: \(anchor)")
//
//        }
//        healthStore.execute(anchoredQuery)
//
//    }
//
//    func checkSourceAndScheduleNotifications(workout: HKWorkout) {
//
//        let currentSource = HKSource.default()
//
//        let sourceRevision = workout.sourceRevision
//        if sourceRevision.source == currentSource {
//            self.notifications.scheduleNotification(workout: workout)
//        }
//        else {
//            print("Recorded by an app called \(sourceRevision.source.name)")
//        }
//    }
//
//}
//
////private enum HealthkitSetupError: Error {
////    case notAvailableOnDevice
////    case dataTypeNotAvailable
////}
