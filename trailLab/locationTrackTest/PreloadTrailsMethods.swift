//
//  PreloadTrailsMethods.swift
//  Trail Lab
//
//  Created by Nika on 3/21/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation



func preloadTrails(loc: CLLocation, radius: Double) {
    
    let databaseRef = FIRDatabase.database().reference()
    databaseRef.child("Trails").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
        
        if snapshot.hasChildren() {
            
            let value = snapshot.value as! NSDictionary
            
            let unicueID = value["unicueID"] as? String
            let userId = value["userId"] as? String
            let activityType = value["activityType"] as? String ?? ""
            let activityName = value["activityName"] as? String
            let distance = value["distance"] as? String ?? ""
            let locations = value["locations"] as! [AnyObject]
            let time = value["time"] as? String ?? ""
            let pace: [Int]? = value["pace"] as? [Int] ?? [0]
            let altitudes: [Double]? = value["altitudes"] as? [Double] ?? [0]
            let difficulty = value["difficulty"] as? [String] ?? [""]
            let suitability = value["suitability"] as? [String] ?? [""]
            let whatToSee = value["watToSee"] as? [String] ?? [""]
            let description = value["description"]  as? String ?? ""
            let pictureURL = value["pictureURL"]  as? String
            
                var coordinate₀: CLLocation!

                let latitude = locations[0]["Latitude"] as! CLLocationDegrees
                let longitude = locations[0]["Longitude"] as! CLLocationDegrees
                
                coordinate₀ = CLLocation(latitude: latitude, longitude: longitude)
            
            let distanceInMeters = coordinate₀.distance(from: loc) // result is in meters
            let distanceInMiles = distanceInMeters * 0.000621371192 //In Miles
            
            
           if distanceInMiles <= radius {
            trails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace!, altitudes: altitudes!, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL), at: 0)
        }
            
        }
    }) { (error) in
        print(error.localizedDescription)
    }

}


func preloadTrailsforProfile() {
    let databaseRef = FIRDatabase.database().reference()
    
    databaseRef.child("Trails").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
        
        if snapshot.hasChildren() {
            
            let value = snapshot.value as! NSDictionary
            
            let unicueID = value["unicueID"] as? String
            let userId = value["userId"] as? String
            let activityType = value["activityType"] as? String ?? ""
            let activityName = value["activityName"] as? String
            let distance = value["distance"] as? String ?? ""
            let locations = value["locations"] as! [AnyObject]
            let time = value["time"] as? String ?? ""
            let pace = value["pace"] as? [Int] ?? [0]
            let altitudes = value["altitudes"] as? [Double] ?? [0]
            let difficulty = value["difficulty"] as? [String] ?? [""]
            let suitability = value["suitability"] as? [String] ?? [""]
            let whatToSee = value["watToSee"] as? [String] ?? [""]
            let description = value["description"]  as? String ?? ""
            let pictureURL = value["pictureURL"]  as? String
            
            let curUserID = FIRAuth.auth()?.currentUser?.uid
            if curUserID == userId {
                if activityType == "Walk" {
                    walkTrails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL), at: 0)
                } else if activityType == "Run" {
                    runTrails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                } else if activityType == "Hike" {
                    hikeTrails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                } else if activityType == "Bike" {
                    bikeTrails.insert(Trail(unicueID: unicueID,  userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL), at: 0)
                }
            }
        }
    }) { (error) in
        print(error.localizedDescription)
    }
    
}