//
//  TracksVC.swift
//  Trail Lab
//
//  Created by Nika on 1/31/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase

class TracksVC: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var trails = [Trail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
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

                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
       
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
    
        //MARK -TV
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return trails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TracksVCCellTableViewCell
        
         cell.nameLabel.text = trails[indexPath.row].activityName
        let url = trails[indexPath.row].pictureURL
        if url != "" {
            self.getImage(url!, imageView: cell.cellImage)

        } else {
            cell.cellImage.image =  UIImage(named:"img-default")
        }
        
        cell.cellImage.contentMode = .scaleAspectFill
        cell.cellImage.clipsToBounds = true
        cell.cellImage.isUserInteractionEnabled = true
        cell.cellImage.layer.cornerRadius = cell.cellImage.frame.height/2
        cell.cellImage.layer.borderWidth = 2
        cell.cellImage.clipsToBounds = true
        
        let type = trails[indexPath.row].activityType
        if type == "Walk" {
            cell.cellImage.layer.borderColor = walkColor().cgColor
        } else if type == "Run" {
            cell.cellImage.layer.borderColor = runColor().cgColor
        } else if type == "Hike" {
            cell.cellImage.layer.borderColor = hikeColor().cgColor
        } else if type == "Bike" {
            cell.cellImage.layer.borderColor = bikeColor().cgColor
        } else {
            cell.cellImage.layer.borderColor = UIColor.white.cgColor
        }
        
        cell.starBut.tag = indexPath.row
        cell.starBut.addTarget(self, action: Selector(("launchStar")), for: .touchUpInside)
        
        
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trails.count
    }

    //MARK -CV
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TracksCVCell", for: indexPath)
        
        cell.backgroundColor = .red
        
        let CVImage = cell.viewWithTag(1) as! UIImageView
        
        CVImage.contentMode = .scaleAspectFill
        CVImage.clipsToBounds = true
        CVImage.isUserInteractionEnabled = true
        CVImage.layer.cornerRadius = CVImage.frame.height/2
        CVImage.layer.borderWidth = 2
        CVImage.clipsToBounds = true
        
        let url = trails[indexPath.row].pictureURL
        if url != "" {
             DispatchQueue.main.async {
            self.getImage(url!, imageView: CVImage)
            }
        } else {
            CVImage.image =  UIImage(named:"img-default")
        }

        let type = trails[indexPath.row].activityType
        if type == "Walk" {
            CVImage.layer.borderColor = walkColor().cgColor
        } else if type == "Run" {
            CVImage.layer.borderColor = runColor().cgColor
        } else if type == "Hike" {
            CVImage.layer.borderColor = hikeColor().cgColor
        } else if type == "Bike" {
            CVImage.layer.borderColor = bikeColor().cgColor
        } else {
            CVImage.layer.borderColor = UIColor.white.cgColor
        }

        
        return cell
        
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

}
