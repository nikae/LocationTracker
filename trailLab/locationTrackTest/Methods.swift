//
//  Methods.swift
//  Trail Lab
//
//  Created by Nika on 2/7/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import UIKit
import Firebase


struct Trail {
    
    let unicueID : String!
    let userId : String!
    let activityType : String!
    let activityName : String!
    let distance : String
    var locations : [AnyObject]
    let time : String!
    var pace : [Int]
    var altitudes : [Double]
    let difficulty : [String]
    let suitability : [String]
    let whatToSee : [String]
    let description : String!
    let pictureURL : String!
}


func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let newHeight = newWidth
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let imageView: UIImageView = UIImageView(image: newImage)
    // imageView.contentMode = .scaleAspectFill
    var layer: CALayer = CALayer()
    layer = imageView.layer
    layer.borderWidth = 0.9
    layer.borderColor = UIColor.gray.cgColor
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(newHeight/2)
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage!
}


func getItemImage(item: UITabBarItem) {
    if let savedImgData = profilePictureDefoults.object(forKey: "image") as? NSData
    {
        if let image = UIImage(data: savedImgData as Data)
        {
            item.selectedImage  = resizeImage(image: image, newWidth: 30).withRenderingMode(.alwaysOriginal)
            item.image  = resizeImage(image: image, newWidth: 30).withRenderingMode(.alwaysOriginal)
            
            
        } else {
            item.selectedImage = resizeImage(image: (UIImage(named:"img-default"))!, newWidth: 30).withRenderingMode(.alwaysOriginal)
            item.image  = resizeImage(image: (UIImage(named:"img-default"))!, newWidth: 30).withRenderingMode(.alwaysOriginal)
        }
        
    }
}


func getImage(_ url:String, imageView: UIImageView) {
    var image = UIImage()
    FIRStorage.storage().reference(forURL: url).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
        if error != nil {
            print(error?.localizedDescription ?? "ERROR")
            image = UIImage(named:"img-default")!
        } else {
            //Dispatch the main thread here
            DispatchQueue.main.async {
                image = UIImage(data: data!)!
                imageView.image = image
            }
        }
    })
}


func sliderFunc(slider: UISlider, color: UIColor, image: UIImage, min: Double, max: Double) {
    slider.minimumTrackTintColor = color
    slider.minimumValueImage = image
    slider.maximumValue = Float(max)
    slider.minimumValue = 0
    slider.value = Float(min)
    slider.isUserInteractionEnabled = false
}


func setGoals() {
        if activity_String == "Walk" {
            walkGoal += distanceTraveled
        } else if activity_String == "Run" {
            runGoal += distanceTraveled
        } else if activity_String == "Hike" {
            hikeGoal += distanceTraveled
        } else if activity_String == "Bike" {
            bikeGoal += distanceTraveled
    }
}


func saveTotalResults() {
    
    let databaseRef = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    databaseRef.child("Results/\(userID!)/walkGoal").setValue(walkGoal)
    databaseRef.child("Results/\(userID!)/runGoal").setValue(runGoal)
    databaseRef.child("Results/\(userID!)/hikeGoal").setValue(hikeGoal)
    databaseRef.child("Results/\(userID!)/bikeGoal").setValue(bikeGoal)
    
    //databaseRef.child("Results/\(userID!)/lifeTime_Distance").setValue(lifeTime_Distance)
    databaseRef.child("Results/\(userID!)/lifeTime_Time").setValue(lifeTime_Time)
    databaseRef.child("Results/\(userID!)/lifeTime_Pace").setValue(lifeTime_Pace)
    databaseRef.child("Results/\(userID!)/lifeTime_MaxAltitude").setValue(lifeTime_MaxAltitude)
    databaseRef.child("Results/\(userID!)/totalActivities").setValue(lifeTime_Activities)
    
   // goalsDefoultsFunc()

}



func goalsDefoultsFunc(){
    walkGoalDefoults.set(walkGoal, forKey: walkGoalDefoults_Key)
    walkGoalDefoults.synchronize()
    runGoalDefoults.set(runGoal, forKey: runGoalDefoults_Key)
    runGoalDefoults.synchronize()
    hikeGoalDefoults.set(hikeGoal, forKey: hikeGoalDefoults_Key)
    hikeGoalDefoults.synchronize()
    bikeGoalDefoults.set(bikeGoal, forKey: bikeGoalDefoults_Key)
    bikeGoalDefoults.synchronize()
    
    lifeTime_TimeDefoults.set(lifeTime_Time, forKey: lifeTime_TimeDefoults_key)
    lifeTime_TimeDefoults.synchronize()
    lifeTime_PaceDefoults.set(lifeTime_Pace, forKey: lifeTime_PaceDefoults_Key)
    lifeTime_PaceDefoults.synchronize()
    lifeTime_MaxAltitudeDefoults.set(lifeTime_MaxAltitude, forKey: lifeTime_MaxAltitudeDefoults_key)
    lifeTime_MaxAltitudeDefoults.synchronize()
    lifeTime_ActivitiesDefoults.set(lifeTime_Activities, forKey: lifeTime_ActivitiesDefoults_Key)
    lifeTime_ActivitiesDefoults.synchronize()
}

func getgoalsDefoultsFunc() {
    walkGoal = walkGoalDefoults.value(forKey: walkGoalDefoults_Key) as? Double ?? 0
    runGoal = runGoalDefoults.value(forKey: runGoalDefoults_Key) as? Double ?? 0
    hikeGoal = hikeGoalDefoults.value(forKey: hikeGoalDefoults_Key) as? Double ?? 0
    bikeGoal = bikeGoalDefoults.value(forKey: bikeGoalDefoults_Key) as? Double ?? 0
  
    lifeTime_Time = lifeTime_TimeDefoults.value(forKey: lifeTime_TimeDefoults_key) as? Double ?? 0
    lifeTime_Pace =  lifeTime_PaceDefoults.value(forKey:  lifeTime_PaceDefoults_Key) as? Int ?? 0
    lifeTime_MaxAltitude = lifeTime_MaxAltitudeDefoults.value(forKey: lifeTime_MaxAltitudeDefoults_key) as? Double ?? 0
    lifeTime_Activities = lifeTime_ActivitiesDefoults.value(forKey: lifeTime_ActivitiesDefoults_Key) as? Int ?? 0
}




func clearGoalsDefoultsFunc(){
    walkGoalDefoults.set(nil, forKey: walkGoalDefoults_Key)
    walkGoalDefoults.synchronize()
    runGoalDefoults.set(nil, forKey: runGoalDefoults_Key)
    runGoalDefoults.synchronize()
    hikeGoalDefoults.set(nil, forKey: hikeGoalDefoults_Key)
    hikeGoalDefoults.synchronize()
    bikeGoalDefoults.set(nil, forKey: bikeGoalDefoults_Key)
    bikeGoalDefoults.synchronize()
    
    lifeTime_TimeDefoults.set(nil, forKey: lifeTime_TimeDefoults_key)
    lifeTime_TimeDefoults.synchronize()
    lifeTime_PaceDefoults.set(nil, forKey: lifeTime_PaceDefoults_Key)
    lifeTime_PaceDefoults.synchronize()
    lifeTime_MaxAltitudeDefoults.set(nil, forKey: lifeTime_MaxAltitudeDefoults_key)
    lifeTime_MaxAltitudeDefoults.synchronize()
    lifeTime_ActivitiesDefoults.set(nil, forKey: lifeTime_ActivitiesDefoults_Key)
    lifeTime_ActivitiesDefoults.synchronize()
    
    walkGoal = 0
    runGoal = 0
    hikeGoal = 0
    bikeGoal = 0
    
    lifeTime_Distance = 0
    lifeTime_Time = 0
    lifeTime_Pace = 0
    lifeTime_MaxAltitude = 0
    lifeTime_Activities = 0

}


// Total Activitie Time To Return
func calculateTotalTime(time: TimeInterval) -> String {
    var timePassed1 = time
    let hours = UInt8(timePassed1 / 3600.0)
    timePassed1 -= (TimeInterval(hours) * 3600)
    let minutes = UInt8(timePassed1 / 60.0)
    timePassed1 -= (TimeInterval(minutes) * 60)
    let seconds = UInt8(timePassed1)
    timePassed1 -= TimeInterval(seconds)
    //let millisecsX10 = UInt8(timePassed * 100)
    
    let strHours = String(format: "%02d", hours)
    let strMinutes = String(format: "%02d", minutes)
    let strSeconds = String(format: "%02d", seconds)
    //let strMSX10 = String(format: "%02d", millisecsX10)
    
    return "\(strHours):\(strMinutes):\(strSeconds)"
    
}

//MARK -delateImage
func delataImage(url: String) {
    let storageRef = FIRStorage.storage().reference()
    let desertRef = storageRef.storage.reference(forURL: url)
    
    // Delete the file
    desertRef.delete { error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Image Is delated")
        }
    }
}


//MARK -Button Shape

func buttShape(but: UIButton, color: UIColor) {
    but.backgroundColor = color
    but.clipsToBounds = true
    but.layer.cornerRadius = but.frame.height/2
   // but.layer.shadowRadius
}



