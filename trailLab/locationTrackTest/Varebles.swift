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
import Firebase
import CoreLocation

//MARK: -UsersDefoult
let sportsButtonDefoults = UserDefaults.standard
let profilePictureDefoults = UserDefaults.standard
let keepMeLogedInDefoultsDefoults = UserDefaults.standard

let firstNameDefoults = UserDefaults.standard
let lastNameDefoults = UserDefaults.standard
let emailDefoults = UserDefaults.standard

let sportsButtonDefoultsKey = "sportsButtonDefoultsKey"
let sportsButtonDefoultsKey_End = "sportsButtonDefoultsKey_End"
let keepMeLogedInDefoults_key = "keepMeLogedInDefoults_key"
let firstNameDefoults_Key = "firstNameDefoults_Key"
let lastNameDefoults_Key = "lastNameDefoults_Key"
let emailDefoults_Key = "emailDefoults_Key"

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
var arrayOfDifficulty : [String] = []
var arrayOfSuitability: [String] = []
var arrayOfWhatToSee: [String] = []

//System Sounds
let systemSoundID: SystemSoundID = 1104

var myLocations: [CLLocation] = []
var coordinates : [CLLocationCoordinate2D] = []
var cordinatesArray: [AnyObject] = []

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

var maxAltitude: Double = 0
var stars = 0
var favBool = false

//Profile view animation
let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let distance_W_LabelHeader:CGFloat = 30.0 // The distance between the top of the screen and the top of the White Label



// Goales - totall results
let arrayOfGoals: [Double] = [50, 75, 100, 150, 200, 300, 500, 1000, 5000, 10000, 100000]

var timePassedToSave = TimeInterval()

var walkGoal: Double = 0
var runGoal: Double = 0
var hikeGoal: Double = 0
var bikeGoal: Double = 0

let walkGoalDefoults = UserDefaults.standard
let runGoalDefoults = UserDefaults.standard
let hikeGoalDefoults = UserDefaults.standard
let bikeGoalDefoults = UserDefaults.standard
let lifeTime_DistanceDefoults = UserDefaults.standard
let lifeTime_TimeDefoults = UserDefaults.standard
let lifeTime_PaceDefoults = UserDefaults.standard
let lifeTime_MaxAltitudeDefoults = UserDefaults.standard
let lifeTime_ActivitiesDefoults = UserDefaults.standard

let walkGoalDefoults_Key = "walkGoalDefoults_Key"
let runGoalDefoults_Key = "runGoalDefoults_Key"
let hikeGoalDefoults_Key = "hikeGoalDefoults_Key"
let bikeGoalDefoults_Key = "bikeGoalDefoults_Key"
let lifeTime_DistanceDefoults_key = "lifeTime_DistanceDefoults_key"
let lifeTime_TimeDefoults_key = "lifeTime_TimeDefoults_key"
let lifeTime_PaceDefoults_Key = "lifeTime_PaceDefoults_Key"
let lifeTime_MaxAltitudeDefoults_key = "lifeTime_MaxAltitudeDefoults_key"
let lifeTime_ActivitiesDefoults_Key = "lifeTime_ActivitiesDefoults_Key"

let goal = arrayOfGoals[0]

var lifeTime_Distance: Double = 0
var lifeTime_Time: Double = 0
var lifeTime_Pace: String = ""
var lifeTime_MaxAltitude: Double = 0
var lifeTime_Activities = 0

//testing
var trails: [Trail] = []
var usersTrails = [Trail]()
var walkTrails = [Trail]()
var runTrails = [Trail]()
var hikeTrails = [Trail]()
var bikeTrails = [Trail]()


var radiusOfLoadingTrails: Double = 2000

var coordinate₁: CLLocation!

