//
//  Varebles.swift
//  Trail Lab
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
let keepMeLogedInDefoultsDefoults = UserDefaults.standard

let firstNameDefoults = UserDefaults.standard
let lastNameDefoults = UserDefaults.standard

let sportsButtonDefoultsKey = "sportsButtonDefoultsKey"
let sportsButtonDefoultsKey_End = "sportsButtonDefoultsKey_End"
let keepMeLogedInDefoults_key = "keepMeLogedInDefoults_key"
let firstNameDefoults_Key = "firstNameDefoults_Key"
let lastNameDefoults_Key = "lastNameDefoults_Key"

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

var imageWalkString_25 = "Walking_000000_25"
var imageRunString_25 = "Running_000000_25"
var imageHikeString_25 = "Trekking_000000_25"
var imageBikeString_25 = "Cycling Mountain Bike_000000_25"

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

//Activity Name and Collor 
var activity_String = ""
var activityColor = UIColor()

//Time managinhg for pace
var zeroTime = TimeInterval()
var timer : Timer = Timer()


//Calculate Distance
var startLocation: CLLocation!
var lastLocation: CLLocation!
var distanceTraveled = 0.0

var arrayOfAltitude: [Double] = []

//Profile view animation
let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let distance_W_LabelHeader:CGFloat = 30.0 // The distance between the top of the screen and the top of the White Label





