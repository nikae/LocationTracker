//
//  Methods.swift
//  Trail Lab
//
//  Created by Nika on 2/7/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import HealthKit

struct Trail {
    let userId : String!
    let activityType : String!
    let activityName : String!
    let distance : String
    let locations : AnyObject!
    let time : String!
    let pace : [Int]
    let altitudes : [Double]
    let difficulty : [String]
    let suitability : [String]
    let whatToSee : [String]
    let description : String!
    let pictureURL : String!
}
