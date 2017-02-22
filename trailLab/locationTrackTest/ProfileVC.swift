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


class ProfileVC: UIViewController, UITabBarDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
       
        let firstName = firstNameDefoults.object(forKey: firstNameDefoults_Key)
        let lastName = lastNameDefoults.object(forKey: lastNameDefoults_Key)
        if firstName != nil && lastName != nil {
            handleLabel.text = "\((firstName as! String).capitalized) \((lastName as! String).capitalized)"
        } else {
            handleLabel.text = "User"
        }

        
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, 0, 0)
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 0.5
        profileImage.clipsToBounds = true
        
        goalSlider.minimumTrackTintColor = walkColor()
        goalSlider.minimumValueImage = UIImage(named: imageWalkString_25)
        value = slider.run
        
        if let savedImgData = profilePictureDefoults.object(forKey: "image") as? NSData
        {
            if let image = UIImage(data: savedImgData as Data)
            {
                profileImage.image = image
            } else {
                profileImage.image = UIImage(named:"img-default")
            }
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
        
        var cnt = 0
        switch segmentedController.selectedSegmentIndex {
        case 0:
            cnt = 20
        case 1:
            cnt = 40
        default :
            break
        }
        
        return cnt
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var str = ""
        switch segmentedController.selectedSegmentIndex {
        case 0:
           str = "test"
        case 1:
           str = "TEST"
            default :
            break
        }
        
         cell.textLabel?.text = str
        
        return cell
    }
    //MARK -segmented controller
    @IBAction func segmentedControllerHit(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
     
    
    //Mark -Slider / Tap Action
    var value = slider.walk
    @IBAction func tapChangeSlidersValues(_ sender: UITapGestureRecognizer) {
        
        if case .run = value {
            goalSlider.minimumTrackTintColor = runColor()
            goalSlider.minimumValueImage = UIImage(named: imageRunString_25)
            value = slider.hike
        } else if case .hike = value {
            goalSlider.minimumTrackTintColor = hikeColor()
            goalSlider.minimumValueImage = UIImage(named: imageHikeString_25)
            value = slider.bike
        } else if case .bike = value {
            goalSlider.minimumTrackTintColor = bikeColor()
            goalSlider.minimumValueImage = UIImage(named: imageBikeString_25)
            value = slider.walk
        } else {
            goalSlider.minimumTrackTintColor = walkColor()
            goalSlider.minimumValueImage = UIImage(named: imageWalkString_25)
            value = slider.run
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
