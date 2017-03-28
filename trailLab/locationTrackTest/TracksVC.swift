//
//  TracksVC.swift
//  Trail Lab
//
//  Created by Nika on 1/31/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class TracksVC: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileTabBarItem: UITabBarItem!
    @IBOutlet weak var segmentControler: UISegmentedControl!
    
   
    var testArr: [Trail] = []
    var favoriteTrails: [Trail] = []
    var favs = [UIImage](repeating: UIImage(named: "Star_000000_25")!, count: (trails.count))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
        
        if trails.count != 0 {
        for i in (0...trails.count - 1) {
            let uid = FIRAuth.auth()?.currentUser?.uid
            if  trails[i].fav[uid!] != true {
            favs[i] = UIImage(named: "Star_000000_25")!
            } else {
            favs[i] = UIImage(named: "Star_Black_000000_25")!
            }
        }
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
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.difficultyLabel.adjustsFontSizeToFitWidth = true
        cell.accLabel.adjustsFontSizeToFitWidth = true
        
        
        if trails[indexPath.row].difficulty.count > 0 {
            cell.difficultyLabel.text = "Difficulty: \(trails[indexPath.row].difficulty.joined(separator: ", "))"
        } else {
            cell.difficultyLabel.text = "No difficulty data!"
        }
        
        if trails[indexPath.row].whatToSee.count > 0 {
            cell.accLabel.text = trails[indexPath.row].whatToSee.joined(separator: ", ")
        } else {
            cell.accLabel.text = "No what to see data!"
        }

        cell.favoritesLabel.text = "\(trails[indexPath.row].stars!)"
        
        let url = trails[indexPath.row].pictureURL
        
        getImage(url!, imageView: cell.cellImage)
        
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
        cell.starBut.addTarget(self, action: #selector(TracksVC.launchStar), for: .touchUpInside)
        cell.starBut.setImage(favs[indexPath.row], for: .normal)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        testArr.append(trails[indexPath.row])
        self.performSegue(withIdentifier: "Segue5", sender: self)
        
    }
    
    func launchStar(sender: UIButton) {
        print(sender.tag) // This works, every cell returns a different number and in order.
        
        
            let uid = FIRAuth.auth()?.currentUser?.uid
        if  trails[sender.tag].fav[uid!] != true {
            
            if favs[sender.tag] == UIImage(named: "Star_000000_25") {
            favs[sender.tag] = UIImage(named: "Star_Black_000000_25")!
            } else {
            favs[sender.tag] = UIImage(named: "Star_000000_25")!
            }

                let databaseRef = FIRDatabase.database().reference()
                let key = trails[sender.tag].unicueID!
                databaseRef.child("Trails/\(key)/favorites/\(uid!)").setValue(true)
            
                stars = trails[sender.tag].stars!
                stars += 1
                print(stars)
                databaseRef.child("Trails/\(key)/stars").setValue(stars as AnyObject)
            
                
                // saveFavorites(fav: trails[sender.tag])
                favoriteTrails.append(trails[sender.tag])
                collectionView.reloadData()
                tableView.reloadData()

                
            } else {
            if favs[sender.tag] == UIImage(named: "Star_Black_000000_25") {
                favs[sender.tag] = UIImage(named: "Star_000000_25")!
            } else {
                favs[sender.tag] = UIImage(named: "Star_Black_000000_25")!
            }
                let databaseRef = FIRDatabase.database().reference()
                let key = trails[sender.tag].unicueID!
                stars = trails[sender.tag].stars!
                stars -= 1
                print(stars)
                databaseRef.child("Trails/\(key)/stars").setValue(stars as AnyObject)
                databaseRef.child("Trails/\(key)/favorites/\(uid!)").setValue(false)
                //
                ////                    favoriteTrails[sender.tag] = nil
                ////                    collectionView.reloadData()
                //
                tableView.reloadData()
   
        }
            
            
       // } else {
          //         }
        sender.setImage(favs[sender.tag], for: .normal)
    }
    
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Segue5" {
        let dest = segue.destination as! CellOutletFromProfileVC
        
        dest.arr = testArr
        dest.vcId = "TracksVC"
            
        } else if segue.identifier == "filterTrails" {
        let dest = segue.destination as! FilterVC

            dest.viewID = "TracksVC"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        testArr.append(favoriteTrails[indexPath.row])
        self.performSegue(withIdentifier: "Segue5", sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteTrails.count
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
        
        
        let url = favoriteTrails[indexPath.row].pictureURL
        if url != "" {
             DispatchQueue.main.async {
            getImage(url!, imageView: CVImage)
            }
        } else {
            CVImage.image =  UIImage(named:"img-default")
        }

        let type = favoriteTrails[indexPath.row].activityType
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
//    @IBAction func testingDataLoadHit(_ sender: UIBarButtonItem) {
//        if coordinate₁ != nil {
//            if trails.count > 0 {
//                trails.removeAll()
//                walkTrails.removeAll()
//                runTrails.removeAll()
//                hikeTrails.removeAll()
//                bikeTrails.removeAll()
//            }
//            preloadTrails(loc: coordinate₁!, radius: 50)
//            tableView.reloadData()
//            collectionView.reloadData()
//        }
//
//        
//    }
 

    @IBAction func filterHit(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "filterTrails", sender: self)
        
    }
    
}
