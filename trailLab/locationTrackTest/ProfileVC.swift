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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
                
            let userId = value["userId"] as? String
            let activityType = value["activityType"] as? String ?? ""
            let activityName = value["activityName"] as? String
            let distance = value["distance"] as? String ?? ""
            let locations = value["locations"] as AnyObject
            let time = value["time"] as? String ?? ""
            let pace = value["pace"] as? [Int] ?? [0]
            let altitudes = value["altitudes"] as? [Double] ?? [0]
            let difficulty = value["difficulty"] as? [String] ?? [""]
            let suitability = value["suitability"] as? [String] ?? [""]
            let whatToSee = value["watToSee"] as? [String] ?? [""]
            let description = value["description"]  as? String ?? ""
            let pictureURL = value["pictureURL"]  as? String
            
            print(userId ?? "NOUSERID")
            print(activityName ?? "NONAME")
            print(activityType)

            self.trails.insert(Trail(userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                
                
                let curUserID = FIRAuth.auth()?.currentUser?.uid
           if curUserID == userId {
            self.usersTrails.insert(Trail(userId: userId, activityType: activityType ,activityName: activityName, distance: distance, locations: locations, time: time, pace: pace, altitudes: altitudes, difficulty: difficulty, suitability: suitability, whatToSee: whatToSee, description: description, pictureURL: pictureURL ), at: 0)
                }
                
            
            //print("TRAILS \(self.trails)")
           self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }

        
    
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
        
        if usersTrails.count > 0 {
            return usersTrails.count
        } else {
            return 1
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if usersTrails.count > 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let distanceLabel = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        let paceLabel = cell.viewWithTag(3) as! UILabel
        let altitudeLabel = cell.viewWithTag(4) as! UILabel
        let nameLabel = cell.viewWithTag(5) as! UILabel
        //       let difficultyLabel = cell.viewWithTag(6) as! UILabel
        //        let suitabilityLabel = cell.viewWithTag(7) as! UILabel
        let imageCell = cell.viewWithTag(10) as! UIImageView
        
        
        let maxPace = usersTrails[indexPath.row].pace.max
        let maxAltitude = usersTrails[indexPath.row].altitudes.max
        
        distanceLabel.text = usersTrails[indexPath.row].distance
        timeLabel.text = usersTrails[indexPath.row].time
        paceLabel.text = "\(maxPace)"
        altitudeLabel.text = "\(maxAltitude)"
        nameLabel.text = usersTrails[indexPath.row].activityName
        let url = usersTrails[indexPath.row].pictureURL
        if url != "" {
        getImage(url!, imageView: imageCell)
        } else {
            imageCell.image =  UIImage(named:"img-default")
        }
        
        imageCell.contentMode = .scaleAspectFill
        imageCell.clipsToBounds = true
        imageCell.isUserInteractionEnabled = true
        imageCell.layer.cornerRadius = imageCell.frame.height/2
        imageCell.layer.borderWidth = 2
        imageCell.clipsToBounds = true
        
        let type = trails[indexPath.row].activityType
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
        }
         return cell
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

    //MARK -segmented controller
    @IBAction func segmentedControllerHit(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
     
    
    //Mark -Slider / Tap Action
    var valueOfSlider = slider.walk
    @IBAction func tapChangeSlidersValues(_ sender: UITapGestureRecognizer) {
        
        if case .run = valueOfSlider {
            goalSlider.minimumTrackTintColor = runColor()
            goalSlider.minimumValueImage = UIImage(named: imageRunString_25)
            valueOfSlider = slider.hike
        } else if case .hike = valueOfSlider {
            goalSlider.minimumTrackTintColor = hikeColor()
            goalSlider.minimumValueImage = UIImage(named: imageHikeString_25)
            valueOfSlider = slider.bike
        } else if case .bike = valueOfSlider {
            goalSlider.minimumTrackTintColor = bikeColor()
            goalSlider.minimumValueImage = UIImage(named: imageBikeString_25)
            valueOfSlider = slider.walk
        } else {
            goalSlider.minimumTrackTintColor = walkColor()
            goalSlider.minimumValueImage = UIImage(named: imageWalkString_25)
            valueOfSlider = slider.run
        }
        
    }
   
    
    //MARK -ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + headerView.bounds.height
        
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            
            // Hide views if scrolled super fast
            headerView.layer.zPosition = 0
          //  handleLabel.isHidden = true
            
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
           // handleLabel.isHidden = false
            let alignToNameLabel = -offset + handleLabel.frame.origin.y + headerView.frame.height + offset_HeaderStop
            
            headerLabel.frame.origin = CGPoint(x: headerLabel.frame.origin.x, y: max(alignToNameLabel, distance_W_LabelHeader + offset_HeaderStop))
            
                 // Avatar -----------
            
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
                }
                
            }
            
        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
        profileImage.layer.transform = avatarTransform
        
        // Segment control
        
        let segmentViewOffset = profileView.frame.height - segmentedView.frame.height - offset
        
        var segmentTransform = CATransform3DIdentity
        
        // Scroll the segment view until its offset reaches the same offset at which the header stopped shrinking
        segmentTransform = CATransform3DTranslate(segmentTransform, 0, max(segmentViewOffset, -offset_HeaderStop), 0)
        
        segmentedView.layer.transform = segmentTransform
        
        
        // Set scroll view insets just underneath the segment control
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
