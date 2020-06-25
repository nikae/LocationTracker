//
//  PedometerManager.swift
//  Trail Lab
//
//  Created by Nika on 6/23/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import CoreMotion


class PedometerManager: NSObject {
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()

    var numberOfSteps:Int! = 0
    var distance:Double! = 0.0
    var pace: Double?
    var averagePace:Double! = 0.0
    var floorsAscended:Int! = 0
    var floorsDscended:Int! = 0
    var cadence:Double! = 0

    // MARK: - blocks
      /// This block will return steps, distance, averagePage, pace, floor ascended, floor dscended
      public var stepsCountingHandler: ((_ steps: Int, _ distance: Double, _ averagePace : Double, _ pace : Double, _ floorsAscended : Int , _ floorsDscended : Int, _ cadence : Double) -> Void)?


    private func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) { activity in

            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    print("Walking")
                } else if activity.stationary {
                    print("Stationary")
                } else if activity.running {
                    print("Running")
                } else if activity.automotive {
                    print("Automotive")
                }
            }
        }
    }

    private func startCountingSteps(_ startDate: Date) {
        pedometer.startUpdates(from: startDate) { pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            self.setPedometerData(pedData: pedometerData)
            if let handler = self.stepsCountingHandler {
                handler(self.numberOfSteps,
                        self.distance,
                        self.averagePace,
                        self.pace ?? 0,
                        self.floorsAscended,
                        self.floorsDscended,
                        self.cadence)
            }

            DispatchQueue.main.async {
                print(pedometerData.numberOfSteps.stringValue)
            }
        }
    }

    private func setPedometerData(pedData: CMPedometerData) {

          self.numberOfSteps = Int(truncating: pedData.numberOfSteps)
          if let distancee = pedData.distance {
              self.distance = Double(truncating: distancee)
          }
          if let averageActivePace = pedData.averageActivePace {
              self.averagePace = Double(truncating: averageActivePace)
          }
          if let currentPace = pedData.currentPace {
              self.pace = Double(truncating: currentPace)
          }
          if let floors = pedData.floorsAscended {
              self.floorsAscended = Int(truncating: floors)
          }
          if let floors = pedData.floorsDescended {
              self.floorsDscended = Int(truncating: floors)
          }
          if let cadence = pedData.currentCadence {
              self.cadence = Double(truncating: cadence)
          }
      }

     func startMonitoring(_ startDate: Date) {
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps(startDate)
        }
    }

    func stopMonitoring() {
        /// stop pedometer and nil start date

            pedometer.stopUpdates()
            pedometer.stopEventUpdates()
    }

    func resetPedometer() {
//        self.timeElapsed = 0.0
        self.numberOfSteps = 0
        self.distance = 0.0
        self.pace = nil
        self.averagePace = 0.0
        self.floorsAscended = 0
        self.floorsDscended = 0
        self.cadence = 0
    }

}

