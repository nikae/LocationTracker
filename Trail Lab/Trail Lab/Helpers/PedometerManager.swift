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
    private let altimeter = CMAltimeter()

    var numberOfSteps:Int! = 0
    var distance: Meter! = 0.0
    var pace: SecondsPerMeter?
    var averagePace: SecondsPerMeter! = 0.0 //seconds per meter
    var floorsAscended:Int! = 0
    var floorsDscended:Int! = 0
    var cadence:Double! = 0
    var elevation: Double?
    var elevationGain: Double = 0
    var elevationMaxMark: Double = 0
    private var changeInElevation = 0.0

    // MARK: - blocks
      /// This block will return steps, distance, averagePage, pace, floor ascended, floor dscended
      public var pedometerListener: ((_ steps: Int, _ distance: Double, _ averagePace : Double, _ pace : Double, _ floorsAscended : Int , _ floorsDscended : Int, _ cadence : Double) -> Void)?
    // MARK: - blocks
    /// This block will return elevationGain, reletiveAltitude
    public var altimeterListener: ((_ elevationGain: Double, _ reletiveAltitude: Double) -> Void)?

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
            if let handler = self.pedometerListener {
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

        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                if (error == nil) {
                    let newElevation = data?.relativeAltitude.doubleValue ?? 0
                    guard let elevation = self.elevation else {
                        self.elevation = newElevation
                        self.altimeterListener?(0, data?.relativeAltitude.doubleValue ?? 0)
                        return
                    }

                    self.changeInElevation = newElevation - elevation;

                    if newElevation > elevation, abs(self.changeInElevation) > 0.15 {
                        self.elevationGain += self.changeInElevation
                    }
                    self.elevation = newElevation
                    self.altimeterListener?(self.elevationGain,
                                            data?.relativeAltitude.doubleValue ?? 0)
                }
            })
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
        altimeter.stopRelativeAltitudeUpdates()
    }

    func resetPedometer() {
        self.numberOfSteps = 0
        self.distance = 0.0
        self.pace = nil
        self.averagePace = 0.0
        self.floorsAscended = 0
        self.floorsDscended = 0
        self.cadence = 0
        self.elevation = 0
        self.elevationGain = 0
        self.elevationMaxMark = 0
        self.changeInElevation = 0
    }

}

