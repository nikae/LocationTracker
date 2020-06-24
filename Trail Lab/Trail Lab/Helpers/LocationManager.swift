//
//  LocationManager.swift
//  Trail Lab
//
//  Created by Nika on 6/19/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {

    static let shared = LocationManager()

    private var locationEnabled = false
     let locationManager = CLLocationManager()

    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance: Double = 0

    private var locationListener: ((CLLocation) -> ())?
    //private var distanceTraveled: (Double) -> ()?

    private var singleLocationUpdate: ((CLLocation) -> ())?

    var hasPermission: Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        return authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    override init() {
        super.init()

        locationEnabled = CLLocationManager.locationServicesEnabled()
        locationManager.activityType = .fitness
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 0.5
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
    }

    func startLocationUpdates(locationListener listener: @escaping (CLLocation) -> (),
                              onError errorCallback: ((Error) -> ())?) {
        guard locationEnabled else {
            errorCallback?(LocationError.notEnabled)
            return
        }
        guard hasPermission else {
            errorCallback?(LocationError.noPermission)
            return
        }

        locationListener = listener
        locationManager.startUpdatingLocation()
    }

    func stopLocationUpdates(onError errorCallback: ((Error) -> ())?) {
        guard locationEnabled else {
            errorCallback?(LocationError.notEnabled)
            return
        }
        guard hasPermission else {
            errorCallback?(LocationError.notEnabled)
            return
        }
        locationManager.stopUpdatingLocation()
        locationListener = nil
        traveledDistance = 0
        startLocation = nil
        lastLocation = nil
    }

    func getCurrentLocation(block:@escaping (CLLocation)->()) {
        singleLocationUpdate = block
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard var mostAccurateLocation = locations.first else {
            //Log.e(LocationError.noUpdates)
            return
        }
        for location in locations {
            guard location.horizontalAccuracy < mostAccurateLocation.horizontalAccuracy else {
                continue
            }
            guard location.horizontalAccuracy > 0 else {
                continue
            }
            mostAccurateLocation = location
        }

        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            traveledDistance += lastLocation.distance(from: location)
            //            self.distanceTraveled?(traveledDistance)
        }
        lastLocation = locations.last

        if let singleUpdateListener = singleLocationUpdate{
            singleUpdateListener(mostAccurateLocation)
            singleLocationUpdate = nil
        }
        locationListener?(mostAccurateLocation)
        if locationListener == nil{
            // End location updates since no one is listening
            stopLocationUpdates(onError: nil)
        }
    }
}

fileprivate enum LocationError: Error {
    case notEnabled, noPermission, noUpdates
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notEnabled:
            return "Location Services are disabled"
        case .noPermission:
            return "Permission to use location services has not been granted"
        case .noUpdates:
            return "Update locations called with empty or invalid location array"
        }
    }
}
