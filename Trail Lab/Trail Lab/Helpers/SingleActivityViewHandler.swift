//
//  SingleActivityViewHandler.swift
//  Trail Lab
//
//  Created by Nika on 7/16/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import HealthKit
import SwiftUI


class SingleActivityViewHandler: ObservableObject {
    
    @Published var showMap: Bool = false
    @Published var altitudeList: [Double] = []
    @Published var routeWaypoint: [RouteWaypoint] = []
    
    let activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
        
        getWayPointsForTheMap(activity: activity)
    }
    
    func getWaypointsFromHK(activity: Activity, completion: @escaping (_ path: [RouteWaypoint]?, [Double]?) -> Void) {
        guard let activity = activity.hkValue else {
            completion([], [])
            return
        }
        var routeWaypoints: [RouteWaypoint] = []
        var altitudes: [Double] = []
        ActivityDataStore().getLocations(activity) { locations in
            if let locations = locations {
                for location in locations {
                    let color: UIColor = location.speed > 1 ? activity.workoutActivityType.localValue().uiColor() : .red
                    routeWaypoints.append(
                        RouteWaypoint(location: location, color: color))
                   
                    altitudes.append(Double(location.altitude).toMetersOrFeet())
                }
            }

            completion(routeWaypoints, altitudes)
        }
    }

    func getWaypointsFromLocalActivity(activity: Activity, completion: @escaping (_ path: [RouteWaypoint]?) -> Void) {

        var routeWaypoints: [RouteWaypoint] = []
        for location in activity.locations {
            let color: UIColor = location.speed > 1 ? activity.activityType.uiColor() : .red
            routeWaypoints.append(
                RouteWaypoint(location: location, color: color))
        }
        completion(routeWaypoints)
    }
    
    fileprivate func getWayPointsForTheMap(activity: Activity) {
        getWaypointsFromHK(
            activity: self.activity) { waypoints, altitudes in
            DispatchQueue.main.async {
                if let waypoints = waypoints {
                    self.routeWaypoint = waypoints
                    self.showMap = true
                }
                if let altitudes = altitudes {
                    self.altitudeList = altitudes
                }
            }
        }
    }
    
}
