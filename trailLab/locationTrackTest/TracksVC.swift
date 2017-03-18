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
    @IBOutlet weak var profileTabBarItem: UITabBarItem!
    
    @IBOutlet weak var segmentControler: UISegmentedControl!
    
    var trails = [Trail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
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

                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getItemImage(item: profileTabBarItem)
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
        getImage(url!, imageView: cell.cellImage)

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
    
    
    var testArr: [Trail] = []
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        testArr.append(trails[indexPath.row])
        self.performSegue(withIdentifier: "Segue5", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let dest = segue.destination as! CellOutletFromProfileVC
        
       // set a variable in the second view controller with the data to pass
        dest.arr = testArr
        dest.vcId = "TracksVC"
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        testArr.append(trails[indexPath.row])
        self.performSegue(withIdentifier: "Segue5", sender: self)
        
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
        CVImage.isUserInteractionEnabled = true
        CVImage.layer.cornerRadius = CVImage.frame.height/2
        CVImage.layer.borderWidth = 2
        CVImage.clipsToBounds = true
        
        let url = trails[indexPath.row].pictureURL
        if url != "" {
             DispatchQueue.main.async {
            getImage(url!, imageView: CVImage)
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
    
    @IBAction func segmentHit(_ sender: UISegmentedControl) {
        switch (segmentControler.selectedSegmentIndex) {
        case 0:
            break
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TracksMapVC") as! TracksMapVC
            self.present(controller, animated: false, completion: nil)
            break
        default : break
         
        }
    }
}
