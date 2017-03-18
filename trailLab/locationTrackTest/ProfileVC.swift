//
//  ProfileVC.swift
//  Trail Lab
//
//  Created by Nika on 2/1/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase

enum slider {
    case walk, run, hike, bike
}


class ProfileVC: UIViewController, UITabBarDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var trails = [Trail]()
    var usersTrails = [Trail]()
    var walkTrails = [Trail]()
    var runTrails = [Trail]()
    var hikeTrails = [Trail]()
    var bikeTrails = [Trail]()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var totalActivitiesScrollView: UIScrollView!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var headerView : UIView!
    @IBOutlet var profileView : UIView!
    @IBOutlet var segmentedView : UIView!
    @IBOutlet var handleLabel : UILabel!
    @IBOutlet var headerLabel : UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var goalSlider: UISlider!
    @IBOutlet weak var profileTabBarItem: UITabBarItem!
    
    @IBOutlet weak var giveButton: UIButton!
    @IBOutlet weak var indicatorPV: UIActivityIndicatorView!
    
    @IBOutlet weak var totalActivities: UILabel!
    @IBOutlet weak var totalMilsLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var TotalavaragePaceLabel: UILabel!
    @IBOutlet weak var totalMaxAltitudeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getgoalsDefoultsFunc()
        lifeTime_Distance = (walkGoal + runGoal + hikeGoal + bikeGoal)
        
        totalActivities.text = "\(lifeTime_Activities)"
        totalMilsLabel.text = String(format: "%.2f mi", lifeTime_Distance)
        totalTimeLabel.text = calculateTotalTime(time: lifeTime_Time)
        TotalavaragePaceLabel.text = "\(lifeTime_Pace)"
        totalMaxAltitudeLabel.text = String(format: "%.2f ft", lifeTime_MaxAltitude)
       
        goalSlider.isUserInteractionEnabled = false
        
            if let savedImgData = profilePictureDefoults.object(forKey: "image") as? NSData
            {
                if let image = UIImage(data: savedImgData as Data)
                {
                    profileImage.image = image
                } else {
                    profileImage.image = UIImage(named:"img-default")
        }
    }
        let firstName = firstNameDefoults.value(forKey: firstNameDefoults_Key) as! String
        let lastName = lastNameDefoults.value(forKey: lastNameDefoults_Key) as! String
        handleLabel.text = "\(firstName.capitalized) \(lastName.capitalized)"
        
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, 0, 0)
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 0.5
        profileImage.clipsToBounds = true
        
        goalSlider.minimumTrackTintColor = walkColor()
        goalSlider.minimumValueImage = UIImage(named: imageWalkString_25)
        valueOfSlider = slider.run
   
        let databaseRef = FIRDatabase.database().reference()
  
        databaseRef.child("Trails").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
     
            if snapshot.hasChildren() {
   
                
            let value = snapshot.value as! NSDictionary
              
            let unicueID = value["unicueID"] as? String
            let userId = value["userId"] as? String
            let activityType = value["activityType"] as? String ?? ""
            let activityName = value["activityName"] as? String
            let distance = value["distance"] as? String ?? ""
            let locations = value["locations"] as! [AnyObject]
            let time = value["time"] as? String ?? ""
            let pace = value["pace"] as? [Int] ?? [0]
            let altitudes = value["altitudes"] as? [Double] ?? [0]
            let difficulty = value["difficulty"] as? [String] ?? [""]
            let suitability = value["suitability"] as? [String] ?? [""]
            let whatToSee = value["watToSee"] as? [String] ?? [""]
            let description = value["description"]  as? String ?? ""
            let pictureURL = value["pictureURL"]  as? String
 
                self.trails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                
                
            let curUserID = FIRAuth.auth()?.currentUser?.uid
            if curUserID == userId {
            self.usersTrails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
//working on Now
                if activityType == "Walk" {
                   self.walkTrails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                } else if activityType == "Run" {
                    self.runTrails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                } else if activityType == "Hike" {
                    self.hikeTrails.insert(Trail(unicueID: unicueID, userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                } else if activityType == "Bike" {
                    self.bikeTrails.insert(Trail(unicueID: unicueID,  userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                }
            }
                
            
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
   }
    
    override func viewWillAppear(_ animated: Bool) {
        getItemImage(item: profileTabBarItem)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        totalActivitiesScrollView.contentSize = CGSize(width: 600, height: totalActivitiesScrollView.frame.height)
    }

    //MARK -TabBar controller
    var viewController0: UIViewController?
    var viewController1: UIViewController?
    var viewController2: UIViewController?
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
        case 0:
            if viewController0 == nil {
                
                viewController0 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as!  ViewController
                
            }
            present(viewController0!, animated: false, completion: nil)
            break
        case 1:
            if viewController1 == nil {
                
                viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TracksVC") as! TracksVC
            }
            present(viewController1!, animated: false, completion: nil)
            break
            
        case 2:
            if viewController2 == nil {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController2 = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            }
            present(viewController2!, animated: false, completion: nil)
            break
            
        default:
            break
        }
    }
    
    // MARK: -Table view processing
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch (segmentedController.selectedSegmentIndex) {
        case 0: returnValue = walkTrails.count
            break
        case 1: returnValue = runTrails.count
            break
        case 2: returnValue = hikeTrails.count
            break
        case 3: returnValue = bikeTrails.count
        default :
            break
        }
        
        if returnValue > 0 {
            return returnValue
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        var returnValue = 0
        
        switch (segmentedController.selectedSegmentIndex) {
        case 0: returnValue = walkTrails.count
        sliderFunc(slider: goalSlider, color: walkColor(), image: UIImage(named: imageWalkString_25)!, min: walkGoal, max: goal)
        valueOfSlider = slider.run
            break
        case 1: returnValue = runTrails.count
        sliderFunc(slider: goalSlider, color: runColor(), image: UIImage(named: imageRunString_25)!, min: runGoal, max: goal)
        valueOfSlider = slider.hike
            break
        case 2: returnValue = hikeTrails.count
        sliderFunc(slider: goalSlider, color: hikeColor(), image: UIImage(named: imageHikeString_25)!, min: hikeGoal, max: goal)
        valueOfSlider = slider.bike
            break
        case 3: returnValue = bikeTrails.count
        sliderFunc(slider: goalSlider, color: bikeColor(), image: UIImage(named: imageBikeString_25)!, min: bikeGoal, max: goal)
        valueOfSlider = slider.walk
            break
        default :
            break
        }
        
        if returnValue > 0 {
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.isUserInteractionEnabled = true
        
        let distanceLabel = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        let paceLabel = cell.viewWithTag(3) as! UILabel
        let altitudeLabel = cell.viewWithTag(4) as! UILabel
        let nameLabel = cell.viewWithTag(5) as! UILabel
        let difficultyLabel = cell.viewWithTag(6) as! UILabel
        let suitabilityLabel = cell.viewWithTag(7) as! UILabel
        let imageCell = cell.viewWithTag(10) as! UIImageView
        var url = ""
        var type = ""
            switch (segmentedController.selectedSegmentIndex) {
            case 0:
                type = walkTrails[indexPath.row].activityType
                let maxPace = walkTrails[indexPath.row].pace.max
                let maxAltitude = walkTrails[indexPath.row].altitudes.max
                distanceLabel.text =  walkTrails[indexPath.row].distance
                timeLabel.text =  walkTrails[indexPath.row].time
                paceLabel.text = "\(maxPace)"
                altitudeLabel.text = "\(maxAltitude)"
                nameLabel.text =  walkTrails[indexPath.row].activityName
                url =  walkTrails[indexPath.row].pictureURL
                difficultyLabel.text = "\(walkTrails[indexPath.row].difficulty)"
                suitabilityLabel.text = "\(walkTrails[indexPath.row].suitability)"
                
                sliderFunc(slider: goalSlider, color: walkColor(), image: UIImage(named: imageWalkString_25)!, min: walkGoal, max: goal)
                valueOfSlider = slider.run
                
                break
            case 1:
                type = runTrails[indexPath.row].activityType
                let maxPace = runTrails[indexPath.row].pace.max
                let maxAltitude = runTrails[indexPath.row].altitudes.max
                distanceLabel.text =  runTrails[indexPath.row].distance
                timeLabel.text =  runTrails[indexPath.row].time
                paceLabel.text = "\(maxPace)"
                altitudeLabel.text = "\(maxAltitude)"
                nameLabel.text =  runTrails[indexPath.row].activityName
                url = runTrails[indexPath.row].pictureURL
                difficultyLabel.text = "\(runTrails[indexPath.row].difficulty)"
                suitabilityLabel.text = "\(runTrails[indexPath.row].suitability)"
             
                sliderFunc(slider: goalSlider, color: runColor(), image: UIImage(named: imageRunString_25)!, min: runGoal, max: goal)
                valueOfSlider = slider.hike
                
                
                break
            case 2:
                type = hikeTrails[indexPath.row].activityType
                let maxPace = hikeTrails[indexPath.row].pace.max
                let maxAltitude = hikeTrails[indexPath.row].altitudes.max
                distanceLabel.text =  hikeTrails[indexPath.row].distance
                timeLabel.text =  hikeTrails[indexPath.row].time
                paceLabel.text = "\(maxPace)"
                altitudeLabel.text = "\(maxAltitude)"
                nameLabel.text =  hikeTrails[indexPath.row].activityName
                url = hikeTrails[indexPath.row].pictureURL
                difficultyLabel.text = "\(hikeTrails[indexPath.row].difficulty)"
                suitabilityLabel.text = "\(hikeTrails[indexPath.row].suitability)"
                
                sliderFunc(slider: goalSlider, color: hikeColor(), image: UIImage(named: imageHikeString_25)!, min: hikeGoal, max: goal)
                valueOfSlider = slider.bike
                
                break
            case 3:
                type = bikeTrails[indexPath.row].activityType
                let maxPace = bikeTrails[indexPath.row].pace.max
                let maxAltitude = bikeTrails[indexPath.row].altitudes.max
                distanceLabel.text =  bikeTrails[indexPath.row].distance
                timeLabel.text =  bikeTrails[indexPath.row].time
                paceLabel.text = "\(maxPace)"
                altitudeLabel.text = "\(maxAltitude)"
                nameLabel.text =  bikeTrails[indexPath.row].activityName
                url = bikeTrails[indexPath.row].pictureURL
                difficultyLabel.text = "\(bikeTrails[indexPath.row].difficulty)"
                suitabilityLabel.text = "\(bikeTrails[indexPath.row].suitability)"
             
                sliderFunc(slider: goalSlider, color: bikeColor(), image: UIImage(named: imageBikeString_25)!, min: bikeGoal, max: goal)
                valueOfSlider = slider.walk
                
                break
            default :
                break
            }
            
        if url != "" {
        getImage(url, imageView: imageCell)
        } else {
            imageCell.image =  UIImage(named:"img-default")
        }
        
        imageCell.contentMode = .scaleAspectFill
        imageCell.clipsToBounds = true
        imageCell.isUserInteractionEnabled = true
        imageCell.layer.cornerRadius = imageCell.frame.height/2
        imageCell.layer.borderWidth = 2
        imageCell.clipsToBounds = true
            
        if type == "Walk" {
            imageCell.layer.borderColor = walkColor().cgColor
        } else if type == "Run" {
            imageCell.layer.borderColor = runColor().cgColor
        } else if type == "Hike" {
            imageCell.layer.borderColor = hikeColor().cgColor
        } else if type == "Bike" {
            imageCell.layer.borderColor = bikeColor().cgColor
        } else {
            imageCell.layer.borderColor = UIColor.white.cgColor
        }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.isUserInteractionEnabled = false
        }
         return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func removeChild(string: String) {
        let dt = FIRDatabase.database().reference()
        
        dt.child("Trails").child(string).removeValue() { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
    }
    
    func returnAlert(action: UIAlertAction) {
        let alertController = UIAlertController(title: "Delete Trail", message: "Delated Trails Can Not Be Retrived", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default) {
            (action: UIAlertAction) in
            print("User Action Has Canceld")
        }
        
        alertController.addAction(action)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {

            switch (segmentedController.selectedSegmentIndex) {
            case 0:
                let key_walk = self.walkTrails[indexPath.row].unicueID
                let picURL = self.walkTrails[indexPath.row].pictureURL ?? ""
                
                
                let delete = UIAlertAction(title: "Delete", style: .default)
                { (action: UIAlertAction) in
                    
                    if picURL != "" {
                        delataImage(url: picURL)
                    }
                    self.removeChild(string: key_walk!)
                    self.walkTrails.remove(at: indexPath.row)
                    tableView.reloadData()
                    
                }
                
                returnAlert(action: delete)
                
                break
            case 1:
                
                let key_run = runTrails[indexPath.row].unicueID
                let picURL =  runTrails[indexPath.row].pictureURL ?? ""
                
                let delete = UIAlertAction(title: "Delete", style: .default)
                {
                    (action: UIAlertAction) in
                    
                    if picURL != "" {
                        delataImage(url: picURL)
                    }

                    self.removeChild(string: key_run!)
                    self.runTrails.remove(at: indexPath.row)
                    tableView.reloadData()
                }
              
                returnAlert(action: delete)
                
                break
            case 2:
                
                let key_hike = hikeTrails[indexPath.row].unicueID
                let picURL =  hikeTrails[indexPath.row].pictureURL ?? ""
               
                let delete = UIAlertAction(title: "Delete", style: .default)
                { (action: UIAlertAction) in
                    
                    if picURL != "" {
                        delataImage(url: picURL)
                    }
                    self.removeChild(string: key_hike!)
                    self.hikeTrails.remove(at: indexPath.row)
                    tableView.reloadData()
                }
                
                returnAlert(action: delete)
                
                break
            case 3:
                
                let key_bike = bikeTrails[indexPath.row].unicueID
                let picURL =  bikeTrails[indexPath.row].pictureURL ?? ""
                
                let delete = UIAlertAction(title: "Delete", style: .default)
                { (action: UIAlertAction) in
                    if picURL != "" {
                        delataImage(url: picURL)
                    }
                    
                    self.removeChild(string: key_bike!)
                    self.bikeTrails.remove(at: indexPath.row)
                    tableView.reloadData()
                }
                
                returnAlert(action: delete)
                break
            default :
                break
            }
        }
    }
    
    var testArr: [Trail] = []
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
            switch (segmentedController.selectedSegmentIndex) {
        case 0:
            testArr.append(walkTrails[indexPath.row])
            self.performSegue(withIdentifier: "Segue", sender: self)
            break
        case 1:
            testArr.append(runTrails[indexPath.row])
            self.performSegue(withIdentifier: "Segue", sender: self)
            break
        case 2:
            testArr.append(hikeTrails[indexPath.row])
            self.performSegue(withIdentifier: "Segue", sender: self)
            
            break
        case 3:
            testArr.append(bikeTrails[indexPath.row])
            self.performSegue(withIdentifier: "Segue", sender: self)
            break
        default :
            break
        }

        
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let dest = segue.destination as! CellOutletFromProfileVC
        
//        // set a variable in the second view controller with the data to pass
        dest.arr = testArr
         dest.vcId = "ProfileVC"
    }
    
    //MARK -segmented controller
    @IBAction func segmentedControllerHit(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    //Mark -Slider / Tap Action
    var valueOfSlider = slider.walk
    @IBAction func tapChangeSlidersValues(_ sender: UITapGestureRecognizer) {
        
        if case .run = valueOfSlider {
            sliderFunc(slider: goalSlider, color: runColor(), image: UIImage(named: imageRunString_25)!, min: runGoal, max: goal )
            valueOfSlider = slider.hike
        } else if case .hike = valueOfSlider {
            sliderFunc(slider: goalSlider, color: hikeColor(), image: UIImage(named: imageHikeString_25)!, min: hikeGoal, max: goal)
            valueOfSlider = slider.bike
        } else if case .bike = valueOfSlider {
            sliderFunc(slider: goalSlider, color: bikeColor(), image: UIImage(named: imageBikeString_25)!, min: bikeGoal, max: goal)
            valueOfSlider = slider.walk
        } else {
            sliderFunc(slider: goalSlider, color: walkColor(), image: UIImage(named: imageWalkString_25)!, min: walkGoal, max: goal)
            valueOfSlider = slider.run
        }
    }
    
    //MARK -ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + headerView.bounds.height
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN
        if offset < 0  {
            
//            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
//            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2
//            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
//            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
//            headerView.layer.zPosition = 0
            
            
            if offset < -50 {
            tableView.reloadData()
            indicatorPV.startAnimating()
            indicatorPV.isHidden = false
            } else {
            indicatorPV.stopAnimating()
            indicatorPV.isHidden = true
            }
        }
            // SCROLL UP/DOWN
        else {
           
            // Header
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            // profile image
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / profileImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((profileImage.bounds.height * (1.0 + avatarScaleFactor)) - profileImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if profileImage.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                }
            }else {
               
                if profileImage.layer.zPosition >= headerView.layer.zPosition{
                    headerView.layer.zPosition = 2
                    giveButton.layer.zPosition = 3
                    
                }
            }
        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
        profileImage.layer.transform = avatarTransform
        
        // Segment control
        let segmentViewOffset = profileView.frame.height - segmentedView.frame.height - offset
        var segmentTransform = CATransform3DIdentity
  
        segmentTransform = CATransform3DTranslate(segmentTransform, 0, max(segmentViewOffset, -offset_HeaderStop), 0)
        segmentedView.layer.transform = segmentTransform
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(segmentedView.frame.maxY, 0, 0, 0)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func editProfileHit(_ sender: UIBarButtonItem) {
        let editProfileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfile") as! EditProfileVC
        present(editProfileView, animated: true, completion: nil)
    }
    
    @IBAction func logOutHit(_ sender: UIButton) {
       print("NEEDS TO BE CHANGED")
    }
   
}
