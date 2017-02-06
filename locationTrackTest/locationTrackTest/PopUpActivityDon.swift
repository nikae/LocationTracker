//
//  PopUpActivityDon.swift
//  locationTrackTest
//
//  Created by Nika on 1/19/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation


class PopUpActivityDon: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Difficulty
    @IBOutlet weak var easy: UIButton!
    @IBOutlet weak var medium: UIButton!
    @IBOutlet weak var hard: UIButton!
    //Suitability
    @IBOutlet weak var kidFriendly: UIButton!
    @IBOutlet weak var dogFriemdly: UIButton!
    @IBOutlet weak var WeelchairFriendly: UIButton!
    //What To See
    @IBOutlet weak var ViewsButt: UIButton!
    @IBOutlet weak var beachButton: UIButton!
    @IBOutlet weak var riverButton: UIButton!
    @IBOutlet weak var caveButton: UIButton!
    @IBOutlet weak var lakeButton: UIButton!
    @IBOutlet weak var waterFallButton: UIButton!
    @IBOutlet weak var hotSpringsButton: UIButton!
   
    @IBOutlet weak var activityNameTF: UITextField!
 
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var mapView_ActivityDone: MKMapView!
   
    @IBOutlet weak var textView_ActivityDone: UITextView!
   // @IBOutlet weak var textFiled_ActivityDone: UITextField!
    
    @IBOutlet weak var scrollView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView_ActivityDone.layer.borderWidth = 0.5
        textView_ActivityDone.layer.borderColor = UIColor.gray.cgColor
        textView_ActivityDone.layer.cornerRadius = 10
        
        
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textView_ActivityDone.delegate = self
        activityNameTF.delegate = self
        
        activityNameTF.text = activityNameTF_String
        distanceLabel.text = distanceLabel_String
        totalTimeLabel.text = timeLabel_String
        paceLabel.text = paceLabel_String
        altitudeLabel.text = altitudeLabel_String

        let tap = UITapGestureRecognizer(target: self, action: #selector(PopUpActivityDon.addPhoto(_:)))
        tap.numberOfTapsRequired = 1
        
        imageView.addGestureRecognizer(tap)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
    }
    
    //MARK: -Camera / Add Picture
    func addPhoto(_ recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alertController = UIAlertController(title: "Add Photo", message: "", preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) {
            (action: UIAlertAction) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: "Camera", style: .default)
        {
            (action: UIAlertAction) in
           picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) {
            (action: UIAlertAction) in
            print("User Action Has Canceld")
        }

        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info.debugDescription)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else {
            print("Somthing went wrong")
        }
        dismiss(animated: true, completion: nil)
    }

    
    //MARK: -Figour Out KeyBoard / TextView - TextFiled
    //key shows
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView == textView_ActivityDone) {
            moveTextView(textView: textView, distance: -290, up: true)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == textView_ActivityDone) {
            moveTextView(textView: textView, distance: -290, up: false)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Move textField
    func moveTextView(textView: UITextView, distance: Int, up: Bool) {
        let duration = 0.3
        let move: CGFloat = CGFloat(up ? distance : -distance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration)
        scrollView.frame = scrollView.frame.offsetBy(dx: 0, dy: move)
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
    //Dismiss keyboard Tap
    func keyboardDismiss() {
        activityNameTF.resignFirstResponder()
        textView_ActivityDone.resignFirstResponder()
    }
    
    @IBAction func viewTapped(_ sender: AnyObject) {
        keyboardDismiss()
    }

    //MARK: -Figour Out options
    let green1 = UIColor(red: 81/255.0, green:  81/255.0, blue:  81/255.0, alpha: 1)
    let green2 = UIColor(red: 128/255.0, green:  128/255.0, blue:  128/255.0, alpha: 1)
    
    func launchBool(sender: UIButton, bool: Bool) {
        if bool == true {
            let num = sender.title(for: UIControlState())!
            arrayOfWhatToSee.append(num)
            sender.backgroundColor = green2
            print(arrayOfWhatToSee)
            
        } else {
        let num = sender.title(for: UIControlState())!
        if let index = arrayOfWhatToSee.index(of: num) {
            arrayOfWhatToSee.remove(at: index)
        }
        sender.backgroundColor = green1
        print(arrayOfWhatToSee)
        }
    }

    func makeBoolForLaunch(bool: Bool, button: UIButton){
            if bool == true {
                launchBool(sender: button, bool: true)
                
            } else {
                launchBool(sender: button, bool: false)
            }
    }
    
    var launchEasy: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchEasy, button: easy)
        }
    }
    var launchMedium: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchMedium, button: medium)
        }
    }
    var launchHard: Bool = false {
        didSet {
          makeBoolForLaunch(bool: launchHard, button: hard)
        }
    }
    var launchkidFriendly: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchkidFriendly, button: kidFriendly)
        }
    }
    var launchDogFriendly: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchDogFriendly, button: dogFriemdly)
        }
    }
    var launchWeelchairFriendly: Bool = false {
        didSet {
           makeBoolForLaunch(bool: launchWeelchairFriendly, button: WeelchairFriendly)
        }
    }
    var launchViews: Bool = false {
        didSet{
            makeBoolForLaunch(bool: launchViews, button: ViewsButt)
        }
    }
    var launchBeach: Bool = false {
        didSet{
        makeBoolForLaunch(bool: launchBeach, button: beachButton)
        }
    }
    var launchRiver: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchRiver, button: riverButton)
        }
    }
    var launchCave: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchCave, button: caveButton)
        }
    }
    var launchLake: Bool = false {
        didSet{
            makeBoolForLaunch(bool: launchLake, button: lakeButton)
        }
    }
    var launchWaterFall: Bool = false {
        didSet {
            makeBoolForLaunch(bool:launchWaterFall, button: waterFallButton)
        }
    }
    var launchHotSprings: Bool = false {
    didSet {
    makeBoolForLaunch(bool: launchHotSprings, button: hotSpringsButton)
        }
    }
 
  
    
    @IBAction func whatToSeeHit(_ sender: UIButton) {
        AudioServicesPlaySystemSound (systemSoundID)
        if sender.tag == 1 {
            launchEasy = !launchEasy
        } else if sender.tag == 2 {
            launchMedium = !launchMedium
        } else if sender.tag == 3 {
            launchHard = !launchHard
        } else if sender.tag == 4 {
            launchkidFriendly = !launchkidFriendly
        } else if sender.tag == 5 {
            launchDogFriendly = !launchDogFriendly
        } else if sender.tag == 6 {
            launchWeelchairFriendly = !launchWeelchairFriendly
        } else if sender.tag == 7 {
            launchViews = !launchViews
        }else if sender.tag == 8 {
            launchBeach = !launchBeach
        } else if sender.tag == 9 {
            launchRiver = !launchRiver
        } else if sender.tag == 10 {
            launchCave = !launchCave
        } else if sender.tag == 11 {
            launchLake = !launchLake
        } else if sender.tag == 12 {
            launchWaterFall = !launchWaterFall
        } else if sender.tag == 13 {
            launchHotSprings = !launchHotSprings
        }
      
    }
    
    @IBAction func doneActivityHit(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
   
    @IBAction func dismissHit(_ sender: UIButton) {
            self.view.removeFromSuperview()      
    }

}
