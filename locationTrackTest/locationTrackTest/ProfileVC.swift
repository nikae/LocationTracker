//
//  ProfileVC.swift
//  locationTrackTest
//
//  Created by Nika on 2/1/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

enum contentTypes {
    case tweets, media
}


class ProfileVC: UIViewController, UITabBarDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
     var contentToDisplay : contentTypes = .tweets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var totalActivitiesScrollView: UIScrollView!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var headerView : UIView!
    @IBOutlet var profileView : UIView!
    @IBOutlet var segmentedView : UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet var handleLabel : UILabel!
    @IBOutlet var headerLabel : UILabel!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, 0, 0)

        //scrollView.delegate = self
        //totalActivitiesScrollView.delegate = self
        //handleLabel.isHidden = true
        
        
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        avatarImage.isUserInteractionEnabled = true

        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        avatarImage.layer.borderWidth = 0.5
        avatarImage.clipsToBounds = true
        
        if let savedImgData = profilePictureDefoults.object(forKey: "image") as? NSData
        {
            if let image = UIImage(data: savedImgData as Data)
            {
                avatarImage.image = image
            }
        }
    }
    
    
    
    //MARK: -Camera / Add Picture
    func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alertController = UIAlertController(title: "Edit Photo", message: "", preferredStyle: .actionSheet)
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

            let imageData = UIImageJPEGRepresentation(image, 1)
             profilePictureDefoults.set(imageData, forKey: "image")
            profilePictureDefoults.synchronize()
            
            avatarImage.image = image
            
         
            
        } else {
            print("Somthing went wrong")
        }
        dismiss(animated: true, completion: nil)
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
        
        switch contentToDisplay {
        case .tweets:
            return 40
            
        case .media:
            return 20
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        switch contentToDisplay {
        case .tweets:
            cell.textLabel?.text = "Tweet Tweet!"
            
        case .media:
            cell.textLabel?.text = "Piccies!"
            cell.imageView?.image = UIImage(named: "header_bg")
        }
        
        
        
        return cell
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
            
            
            //  ------------ Blur
            
            // headerBlurImageView?.alpha = min (1.0, (offset - alignToNameLabel)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                }
                
                
            }else {
                if avatarImage.layer.zPosition >= headerView.layer.zPosition{
                    headerView.layer.zPosition = 2
                }
                
            }
            
        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
        
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
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func editProfileHit(_ sender: UIBarButtonItem) {
        addPhoto()
    }
   
}
