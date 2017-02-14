//
//  Varebles.swift
//  locationTrackTest
//
//  Created by Nika on 12/11/16.
//  Copyright © 2016 Nika. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AVFoundation

//MARK: -UsersDefoult
let sportsButtonDefoults = UserDefaults.standard
let profilePictureDefoults = UserDefaults.standard
let sportsButtonDefoultsKey = "sportsButtonDefoultsKey"
let sportsButtonDefoultsKey_End = "sportsButtonDefoultsKey_End"

let distanceDefoults = UserDefaults.standard
let distanceDefoultsKey = "distance"

//MARK: -Activity Names
var walkString = "Walk"
var runString = "Run"
var hikeString = "Hike"
var bikeString = "Bike"

//MARK: -Activity Colors
let walkColor = SportColors.color(.walk)
let runColor = SportColors.color(.run)
let hikeColor = SportColors.color(.hike)
let bikeColor = SportColors.color(.bike)

//MARK: -Activity Colors Images String
var imageWalkString_32 = "Walking_000000_32"
var imageRunString_32 = "Running_000000_32"
var imageHikeString_32 = "Trekking_000000_32"
var imageBikeString_32 = "Cycling Mountain Bike_000000_32"

var imageWalkString_50 = "Walking_000000_50"
var imageRunString_50 = "Running_000000_50"
var imageHikeString_50 = "Trekking_000000_50"
var imageBikeString_50 = "Cycling Mountain Bike_000000_50"

var imageCancelString_50 = "Cancel_000000_50"


//MARK: -PolyLine Colors
let polyLineColor_red =  PolyLineColor.color(.red)
let polyLineColor_red1 = PolyLineColor.color(.red1)
let polyLineColor_orange = PolyLineColor.color(.orange)
let polyLineColor_orange1 = PolyLineColor.color(.orange1)
let polyLineColor_yellow = PolyLineColor.color(.yellow)
let polyLineColor_yellow1 = PolyLineColor.color(.yellow1)
let polyLineColor_green = PolyLineColor.color(.grin)

//MARK: -Varables to save / PopUpAvtivity
//Text Fileds
var activityNameTF_String: String = ""
var desctriptionTF_String: String = ""

//Labels
var distanceLabel_String: String = ""
var timeLabel_String: String = ""
var paceLabel_String: String = ""
var altitudeLabel_String: String = ""

//Arrays
var arrayOfWhatToSee: [String] = []

//System Sounds
let systemSoundID: SystemSoundID = 1104

 var myLocations: [CLLocation] = []
 
//var polyline = MKPolyline()

var activity_String = ""

//HealtKit
var zeroTime = TimeInterval()
var timer : Timer = Timer()

//let locationManager = CLLocationManager()
var startLocation: CLLocation!
var lastLocation: CLLocation!
var distanceTraveled = 0.0

//if Ill need enywhere
var heightString_Var = ""

var arrayOfAltitude: [Double] = []

var totalTimeSeconds: Double = 0
var distanceRanInMetres: Double = 0

var paceArray: [Int] = []



let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let distance_W_LabelHeader:CGFloat = 30.0 // The distance between the top of the screen and the top of the White Label

var activityColor = UIColor()





