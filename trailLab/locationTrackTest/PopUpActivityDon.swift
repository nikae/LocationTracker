//
//  PopUpActivityDon.swift
//  Trail Lab
//
//  Created by Nika on 1/19/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import CoreLocation
import Firebase


class PopUpActivityDon: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var users: [FIRDataSnapshot] = []
    //possible Error
    var picURL = ""
    let userID = FIRAuth.auth()?.currentUser?.uid

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
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
   
    @IBOutlet weak var activityNameTF: UITextField!
 
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var mapView_ActivityDone: MKMapView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var UploadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var abc: [[String: AnyObject]] = []

    var manager: CLLocationManager!
    let mapView = MyMapView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceLabel.adjustsFontSizeToFitWidth = true
        totalTimeLabel.adjustsFontSizeToFitWidth = true
        paceLabel.adjustsFontSizeToFitWidth = true
        altitudeLabel.adjustsFontSizeToFitWidth = true
       
        progressView.isHidden = true
        progressView.progressTintColor = walkColor()
        
        getgoalsDefoultsFunc()
        setGoals()
        
        self.UploadIndicator.hidesWhenStopped = true
        
        storageRef = FIRStorage.storage().reference(forURL: "gs://trail-lab.appspot.com")
        databaseRef = FIRDatabase.database().reference()
        
        setUpLocationManager()
        mapView.setUpMapView(view: mapView_ActivityDone, delegate: self)
        mapView.zoomMap(val: 0.04, superVisor: manager,view: mapView_ActivityDone)
        mapView_ActivityDone.showsUserLocation = false
  
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
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
        
        for l in myLocations {
            
            let dict = ["Latitude": l.coordinate.latitude, "Longitude": l.coordinate.longitude]
            cordinatesArray.append(dict as AnyObject)
        }

        coordinates = myLocations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})

        let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        self.mapView_ActivityDone.add(polyline)
        
        buttShape(but: deleteBtn, color: walkColor())
        buttonShedow(but: deleteBtn)
        buttShape(but: saveBtn, color: hikeColor())
        buttonShedow(but: saveBtn)
        
        buttShape(but: easy, color: hikeColor())
        buttShape(but: medium, color: runColor())
        buttShape(but: hard, color: walkColor())
        
        buttShape(but: kidFriendly, color: bikeColor())
        buttShape(but: dogFriemdly, color: runColor())
        buttShape(but: WeelchairFriendly, color: hikeColor())
        
        buttShape(but: ViewsButt, color: walkColor())
        buttShape(but: beachButton, color: bikeColor())
        buttShape(but: riverButton, color: bikeColor())
        buttShape(but: caveButton, color: runColor())
        buttShape(but: lakeButton, color: hikeColor())
        buttShape(but: waterFallButton, color: runColor())
        buttShape(but: hotSpringsButton, color: walkColor())
    }
    
 
    //MARK: -setUp Location Manager
    func setUpLocationManager() {
        if (CLLocationManager.locationServicesEnabled()) {
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.activityType = .fitness
            manager.requestAlwaysAuthorization()
        } else {
            print("Location services are not enabled")
        }
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = blueColor
        polylineRenderer.lineWidth = 5
        return polylineRenderer
        
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
    
    if picURL != "" {
        delataImage(url: picURL)
        self.picURL = ""
    }
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            saveImage(image)
           
        } else {
            print("Somthing went wrong")
        }
        dismiss(animated: true, completion: nil)
    }

    func saveImage(_ image:UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        //(Int(Date.timeIntervalSinceReferenceDate * 1000))
        let imagePath = "\(Date.timeIntervalSinceReferenceDate * 1000).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploasTask = self.storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
            self.picURL = self.storageRef.child((metadata?.path)!).description
        }
        
        uploasTask.observe(.progress, handler: { [weak self] (snapshot) in
            
            guard let strongSelf = self else {return}
            guard let progress = snapshot.progress else {return}
            strongSelf.progressView.progress = Float(progress.fractionCompleted)
            strongSelf.progressView.isHidden = false
            
            if strongSelf.progressView.progress == 1.0 {
                strongSelf.progressView.isHidden = true
            }
            
            
        } )
        
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
    }
    
    @IBAction func viewTapped(_ sender: AnyObject) {
        keyboardDismiss()
    }

    
    func launchBool(sender: UIButton, bool: Bool) {
 
        if bool == true {
            let num = sender.title(for: UIControlState())!
            if sender.tag == 1 || sender.tag == 2 || sender.tag == 3 {
                arrayOfDifficulty.append(num)
                print(arrayOfDifficulty)
            } else if sender.tag == 4 || sender.tag == 5 || sender.tag == 6 {
                arrayOfSuitability.append(num)
                print(arrayOfSuitability)
            } else {
                arrayOfWhatToSee.append(num)
                print(arrayOfWhatToSee)
            }

            sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(0.5)
            
            
        } else {
            let num = sender.title(for: UIControlState())!
           
            if sender.tag == 1 || sender.tag == 2 || sender.tag == 3 {
                if let index = arrayOfDifficulty.index(of: num) {
                    arrayOfDifficulty.remove(at: index)
                    print(arrayOfDifficulty)
                }
                
            } else if sender.tag == 4 || sender.tag == 5 || sender.tag == 6 {
                if let index = arrayOfSuitability.index(of: num) {
                    arrayOfSuitability.remove(at: index)
                    print(arrayOfSuitability)
                }

            } else {
                if let index = arrayOfWhatToSee.index(of: num) {
                    arrayOfWhatToSee.remove(at: index)
                    print(arrayOfWhatToSee)
                }
            }

  
            sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(1)

        }
    }
    
    func makeBoolForLaunch(bool: Bool, button: UIButton, array: [String]){
        if bool == true {
            launchBool(sender: button, bool: true)
            
        } else {
            launchBool(sender: button, bool: false)
        }
    }
    
    var launchEasy: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchEasy, button: easy, array: arrayOfDifficulty)
        }
    }
    var launchMedium: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchMedium, button: medium, array: arrayOfDifficulty)
        }
    }
    var launchHard: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchHard, button: hard, array: arrayOfDifficulty)
        }
    }
    var launchkidFriendly: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchkidFriendly, button: kidFriendly, array: arrayOfSuitability)
        }
    }
    var launchDogFriendly: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchDogFriendly, button: dogFriemdly, array: arrayOfSuitability)
        }
    }
    var launchWeelchairFriendly: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchWeelchairFriendly, button: WeelchairFriendly, array: arrayOfSuitability)
        }
    }
    var launchViews: Bool = false {
        didSet{
            makeBoolForLaunch(bool: launchViews, button: ViewsButt, array: arrayOfWhatToSee)
        }
    }
    var launchBeach: Bool = false {
        didSet{
            makeBoolForLaunch(bool: launchBeach, button: beachButton, array: arrayOfWhatToSee)
        }
    }
    var launchRiver: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchRiver, button: riverButton, array: arrayOfWhatToSee)
        }
    }
    var launchCave: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchCave, button: caveButton, array: arrayOfWhatToSee)
        }
    }
    var launchLake: Bool = false {
        didSet{
            makeBoolForLaunch(bool: launchLake, button: lakeButton, array: arrayOfWhatToSee)
        }
    }
    var launchWaterFall: Bool = false {
        didSet {
            makeBoolForLaunch(bool:launchWaterFall, button: waterFallButton, array: arrayOfWhatToSee)
        }
    }
    var launchHotSprings: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchHotSprings, button: hotSpringsButton, array: arrayOfWhatToSee)
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
    
    func saveTrail() {
       
        let userId = userID
        let activityType = activity_String 
        let activityName = activityNameTF.text ?? activityNameTF_String
        let distance = distanceLabel_String
        let locations = cordinatesArray
        let time = timeLabel_String
        let pace = paceLabel_String
        let altitudes = arrayOfAltitude
        let difficulty = arrayOfDifficulty
        let suitability = arrayOfSuitability
        let watToSee = arrayOfWhatToSee
        let pictureURL = picURL
        let star = stars
        let fav = [userID! : false]
        
        let key = databaseRef.child("Trails").childByAutoId().key
        
        let trailInfo: Dictionary<String, AnyObject> = ["unicueID" : key as AnyObject,
                                                        "userId" : userId as AnyObject,
                                                         "activityType" : activityType as AnyObject,
                                                         "activityName" : activityName as AnyObject,
                                                         "distance" : distance as AnyObject,
                                                         "locations" : locations as AnyObject,
                                                         "time" : time as AnyObject,
                                                         "pace" : pace as AnyObject,
                                                         "altitudes" : altitudes as AnyObject,
                                                         "difficulty" : difficulty as AnyObject,
                                                         "suitability" : suitability as AnyObject,
                                                         "swatToSee" : watToSee as AnyObject,
                                                         "pictureURL" : pictureURL as AnyObject,
                                                         "stars" : star as AnyObject,
                                                          "favorites" : fav as AnyObject]
        
       
       // let childUpdates = ["Trails/\(key)/\(trailInfo)"]
        
        databaseRef.child("Trails").child("\(key)").setValue(trailInfo)
        
    }

    
    @IBAction func doneActivityHit(_ sender: UIButton) {
        lifeTime_Activities += 1
        lifeTime_Time += timePassedToSave
        if maxAltitude > lifeTime_MaxAltitude {
        lifeTime_MaxAltitude = maxAltitude
        }
        lifeTime_Pace = paceLabel_String
        
        saveTrail()
        saveTotalResults()
        goalsDefoultsFunc()
        
        arrayOfWhatToSee.removeAll()
        arrayOfDifficulty.removeAll()
        arrayOfSuitability.removeAll()
        
        distanceTraveled = 0
        timePassedToSave = 0
        myLocations.removeAll()
        self.view.removeFromSuperview()

    }
   
    @IBAction func dismissHit(_ sender: UIButton) {
        self.view.removeFromSuperview()
        if picURL != "" {
            delataImage(url: picURL)
        }
        myLocations.removeAll()
        distanceTraveled = 0
        timePassedToSave = 0
        
        arrayOfWhatToSee.removeAll()
        arrayOfDifficulty.removeAll()
        arrayOfSuitability.removeAll()
    }
    @IBAction func backToMyLocation(_ sender: Any) {
        
        mapView.zoomMap(val: 0.007, superVisor: manager, view: mapView_ActivityDone)
    }

}
