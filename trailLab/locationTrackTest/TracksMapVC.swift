//
//  TracksMapVC.swift
//  Trail Lab
//
//  Created by Nika on 3/16/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class TracksMapVC: UIViewController, UITabBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var profileTabBarItem: UITabBarItem!
    @IBOutlet weak var theMap: MKMapView!
    
    var trails = [Trail]()
    let mapView = MyMapView()
    var manager: CLLocationManager!
    var coordinatesTracksMap: [CLLocationCoordinate2D] = []
    var testArr = [Trail]()
    
    override func viewWillAppear(_ animated: Bool) {
        getItemImage(item: profileTabBarItem)
       
    }

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
                
                for loc in self.trails {
                    self.testArr.append(loc)
                    let name = loc.activityName
                    let desc = loc.description
                    
                    let loce = [loc.locations]
                    
                    for a in loce {
                        
                        let latitude = a[0]["Latitude"] as! CLLocationDegrees
                        let longitude = a[0]["Longitude"] as! CLLocationDegrees
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
                        self.coordinatesTracksMap.append(coordinate)
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = name
                        annotation.subtitle = desc
                        annotation.coordinate = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
                        self.theMap.addAnnotation(annotation)
                    }
                }
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        segmentedControl.selectedSegmentIndex = 1
        
        setUpLocationManager()
        
        mapView.setUpMapView(view: theMap, delegate: self)
        mapView.zoomMap(val: 0.04, superVisor: manager, view: theMap)
        theMap.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 10)
        
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
    //   var colorforPolyline = UIColor()
            polylineRenderer.strokeColor = blueColor

    // polylineRenderer.strokeColor = .black
    polylineRenderer.lineWidth = 5
    return polylineRenderer
    
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
                
                viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TracksMapVC") as! TracksMapVC
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
    @IBAction func segmentedControlHit(_ sender: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TracksVC") as! TracksVC
            self.present(controller, animated: false, completion: nil)
            break
        case 1:
            break
        default : break
        }
    }

}
