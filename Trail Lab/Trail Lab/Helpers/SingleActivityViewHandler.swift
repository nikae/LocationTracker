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

    func getWaypointsFromHK(activity: Activity, completion: @escaping (_ path: [RouteWaypoint]?) -> Void) {
        guard let activity = activity.hkValue else {
            completion([])
            return
        }
        var routeWaypoints: [RouteWaypoint] = []
        ActivityDataStore().getLocations(activity) { locations in
            if let locations = locations {
                for location in locations {
                    let color: UIColor = location.speed > 1 ? activity.workoutActivityType.localValue().uiColor() : .red
                    routeWaypoints.append(
                        RouteWaypoint(location: location, color: color))
                }
            }
            completion(routeWaypoints)
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

}
