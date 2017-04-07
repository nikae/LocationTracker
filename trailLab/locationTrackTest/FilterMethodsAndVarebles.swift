//
//  FilterMethodsAndVarebles.swift
//  Trail Lab
//
//  Created by Nika on 4/3/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase





//func filter(dist: [String], dif: [String], suit: [String], wts: [String], type: [String]) {
//    
//    let databaseRef = FIRDatabase.database().reference()
//    databaseRef.child("Trails").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
//        
//        if snapshot.hasChildren() {
//            
//            let value = snapshot.value as! NSDictionary
//            
//            let unicueID = value["unicueID"] as? String
//            let userId = value["userId"] as? String
//            let activityType = value["activityType"] as? String ?? ""
//            let activityName = value["activityName"] as? String
//            let distance = value["distance"] as? String ?? ""
//            let locations = value["locations"] as? [AnyObject]
//            let time = value["time"] as? String ?? ""
//            let pace = value["pace"] as? String ?? ""
//            let altitudes: [Double]? = value["altitudes"] as? [Double] ?? [0]
//            let difficulty = value["difficulty"] as? [String] ?? []
//            let suitability = value["suitability"] as? [String] ?? []
//            let whatToSee = value["swatToSee"] as? [String] ?? []
//            let description = value["description"]  as? String ?? ""
//            let pictureURL = value["pictureURL"]  as? String
//            let star = value["stars"] as? Int ?? 0
//            let favorite = value["favorites"] as? [String: Bool] ?? ["noUser": false]
//            
//            if locations != nil {
//                var coordinate₀: CLLocation!
//                
//                let latitude = locations?[0]["Latitude"] as! CLLocationDegrees
//                let longitude = locations?[0]["Longitude"] as! CLLocationDegrees
//                
//                coordinate₀ = CLLocation(latitude: latitude, longitude: longitude)
//                
//                let distanceInMeters = coordinate₀.distance(from: coordinate₁!) // result is in meters
//                let distanceInMiles = distanceInMeters * 0.000621371192 //In Miles
//                
//                
//                let radius: Double!
//                if dist != [] {
//                    var distanceIntArr: [Double] = []
//                    for i in dist {
//                        distanceIntArr.append(Double(i)!)
//                    }
//                    radius = distanceIntArr.max()
//                } else {
//                    radius = 60
//                }
//                
//                //Mark: -Filter Distance
//                if distanceInMiles <= radius {
//                    if coordinate₁ != nil {
//                        if trails.count > 0 {
//                            trails.removeAll()
//                        }
//                        
//                        //Mark: -Filter ActivityType
//                        if type != [] {
//                            for i in type {
//                                if i == activityType {
//                                    
//                                    
////                                    //mark: Filter Difficulty
////                                    if dif != [] {
////                                        for f_dif in dif {
////                                            for t_dif in difficulty {
////                                                if f_dif == t_dif {
//                                    
//                                                    trails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations!, time: time, pace: pace, altitudes: altitudes!, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL, stars: star, fav: favorite), at: 0)
//                                                    
////                                                }
////                                            }
////                                            
////                                        }
////                                        
////                                    }
////                                    
//                                    
//                                    
//                                    
//                                    
//                                }
//                            }
//                            
//                        }
//                        
//                        
//                        
//                        
//                        
//                        
//                        
//                    }
//                }
//            }
//        }
//    }) { (error) in
//        print(error.localizedDescription)
//    }
//    
//    
//    
//}
