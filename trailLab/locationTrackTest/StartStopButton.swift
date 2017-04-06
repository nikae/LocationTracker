//
//  StartStopButton.swift
//  Trail Lab
//
//  Created by Nika on 12/11/16.
//  Copyright © 2016 Nika. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct ActivityPicker {
   
    //MARK: -User Defoults for Fports Buttons Views \ Includs NavigationBar Title
    func getSavedSportsButton(button: UIButton, navigationBar: UINavigationBar, off: Bool){
        if off == true {
        switch (sportsButtonDefoults.integer(forKey: sportsButtonDefoultsKey)) {
        case 0:
            self.startButtonView(image: imageWalkString_50, button: button, color: walkColor(), headLineTitle: walkString, navigationBar: navigationBar)
            activity_String = "Walk"
            activityColor = walkColor()
        case 1:
             self.startButtonView(image: imageRunString_50, button: button, color: runColor(),headLineTitle: runString, navigationBar: navigationBar)
            activity_String = "Run"
            activityColor = runColor()
        case 2:
             self.startButtonView(image: imageHikeString_50, button: button, color: hikeColor(),headLineTitle: hikeString, navigationBar: navigationBar)
            activity_String = "Hike"
            activityColor = hikeColor()
        case 3:
             self.startButtonView(image: imageBikeString_50, button: button, color: bikeColor(), headLineTitle: bikeString, navigationBar: navigationBar)
            activity_String = "Bike"
            activityColor = bikeColor()
        default:
             self.startButtonView(image: imageWalkString_50, button: button, color: walkColor(), headLineTitle: walkString, navigationBar: navigationBar)
            activity_String = "Walk"
            activityColor = walkColor()
        }
    } else {
    switch (sportsButtonDefoults.integer(forKey: sportsButtonDefoultsKey_End)) {
    case 0:
    self.startButtonView(image: imageCancelString_50, button: button, color: walkColor(), headLineTitle: walkString, navigationBar: navigationBar)
    case 1:
        self.startButtonView(image: imageCancelString_50, button: button, color: runColor(),headLineTitle: runString, navigationBar: navigationBar)
    case 2:
        self.startButtonView(image: imageCancelString_50, button: button, color: hikeColor(),headLineTitle: hikeString, navigationBar: navigationBar)
    case 3:
        self.startButtonView(image: imageCancelString_50, button: button, color: bikeColor(), headLineTitle: bikeString, navigationBar: navigationBar)
    default:
    self.startButtonView(image: imageCancelString_50, button: button, color: walkColor(), headLineTitle: walkString, navigationBar: navigationBar)
    }

 }
}
    
    //MARK: -Start Button View
    func startButtonView(image: String, button: UIButton, color: UIColor, headLineTitle: String, navigationBar: UINavigationBar) {
        let image = UIImage(named: image) as UIImage?
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = button.frame.height/2
        button.clipsToBounds = true
        button.backgroundColor = color
        
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius =  button.frame.height/2
        button.layer.shadowOffset =  CGSize(width: 0, height: -15)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
        
        navigationBar.topItem?.title = headLineTitle
       

    }
  
    //MARK: -Activity Button Views
    func activityPickerView_Button(image: String, button: UIButton, color: UIColor) {
        let image = UIImage(named: image) as UIImage?
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = button.frame.height/2
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.backgroundColor = color
       
    }
    
    //MARK: -First View of Buttons
    func activityPickerView(view: UIView, walk: UIButton, run: UIButton, hike: UIButton, bike: UIButton) {
       
    view.backgroundColor = UIColor(white: 1, alpha: 0.8)
    view.layer.cornerRadius = 35
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: -0.3)
    view.layer.shadowRadius = 15
    view.layer.shadowOpacity = 0.5
    view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        

    self.activityPickerView_Button(image: imageWalkString_32, button: walk, color: walkColor())
    self.activityPickerView_Button(image: imageRunString_32, button: run, color: runColor())
    self.activityPickerView_Button(image: imageHikeString_32, button: hike, color: hikeColor())
    self.activityPickerView_Button(image: imageBikeString_32, button: bike, color: bikeColor())
        }
    
    //MARK: -Activity View Slider Up\Down
    func moveSportsViewDown(view: UIView, button: UIView, tapGesture: UITapGestureRecognizer, swipeDownGesture: UISwipeGestureRecognizer, swipeUpGesture: UISwipeGestureRecognizer, moveUp: Bool) {
        
        if moveUp == false {
        
        let xPositionOfView = view.frame.origin.x
        let xPositionOfButton = button.frame.origin.x
        
        //View will slide 220px down
        let yPositionOfView = view.frame.origin.y + 220
        let yPositionOfButton = button.frame.origin.y + 220
        let heightOfView = view.frame.size.height
        let widthOfView = view.frame.size.width
            
        let heightOfButton = button.frame.size.height
        let widthOfButton = button.frame.size.width
        
        UIView.animate(withDuration: 1.0, animations: {
            
            view.frame = CGRect(x: xPositionOfView, y: yPositionOfView, width: widthOfView, height: heightOfView)
            button.frame = CGRect(x: xPositionOfButton, y: yPositionOfButton, width: widthOfButton, height: heightOfButton)
        })
        button.isUserInteractionEnabled = true
        tapGesture.isEnabled = true
        swipeUpGesture.isEnabled = true
        swipeDownGesture.isEnabled = false
        } else {
            let xPositionOfView = view.frame.origin.x
            let xPositionOfButton = button.frame.origin.x
            
            //View will slide 220px up
            let yPositionOfView = view.frame.origin.y - 220
            let yPositionOfButton = button.frame.origin.y - 220
            
            let heightOfView = view.frame.size.height
            let widthOfView = view.frame.size.width
            
            let heightOfButton = button.frame.size.height
            let widthOfButton = button.frame.size.width
            
            UIView.animate(withDuration: 1.0, animations: {
                
                view.frame = CGRect(x: xPositionOfView, y: yPositionOfView, width: widthOfView, height: heightOfView)
                button.frame = CGRect(x: xPositionOfButton, y: yPositionOfButton, width: widthOfButton, height: heightOfButton)
                
            })
            button.isUserInteractionEnabled = false
            tapGesture.isEnabled = false
            swipeUpGesture.isEnabled = false
            swipeDownGesture.isEnabled = true
        }
    }
}
