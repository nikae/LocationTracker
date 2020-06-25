//
//  HealthPermisionsHandler.swift
//  Trail Lab
//
//  Created by Nika on 6/18/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import HealthKit

class HealthPermisionsHandler {
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }

    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }

        //TODO: Add charaqteristics when needed
        guard let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            let distanceCycling = HKObjectType.quantityType(forIdentifier: .distanceCycling),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }

        let workoutRoute = HKSeriesType.workoutRoute()
        let workoutType =  HKObjectType.workoutType()

        let healthKitTypesToWrite: Set<HKSampleType> = [
            activeEnergy,
            distanceCycling,
            distanceWalkingRunning,
            stepCount,
            workoutType,
            workoutRoute]

        let healthKitTypesToRead: Set<HKObjectType> = [
            activeEnergy,
            distanceCycling,
            distanceWalkingRunning,
            stepCount,
            workoutType,
            workoutRoute]

        HKHealthStore().requestAuthorization(
            toShare: healthKitTypesToWrite,
            read: healthKitTypesToRead) { (success, error) in
                completion(success, error)
        }
    }
}
