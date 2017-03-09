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
    
    databaseRef.child("Results/\(userID!)/lifeTime_Distance").setValue(lifeTime_Distance)
    databaseRef.child("Results/\(userID!)/lifeTime_Time").setValue(lifeTime_Time)
    databaseRef.child("Results/\(userID!)/lifeTime_Pace").setValue(lifeTime_Pace)
    databaseRef.child("Results/\(userID!)/lifeTime_MaxAltitude").setValue(lifeTime_MaxAltitude)
    
    goalsDefoultsFunc()
    
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
}



