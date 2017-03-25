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
    
    //var trails = [Trail]()
    let mapView = MyMapView()
    var manager: CLLocationManager!
    //var coordinatesTracksMap: [CLLocationCoordinate2D] = []
    var testArr = [Trail]()
    var coordinate: CLLocationCoordinate2D! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        getItemImage(item: profileTabBarItem)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                for loc in trails {
                    let name = loc.activityName
                    let desc = loc.description
                    let url = loc.pictureURL
                    let type = loc.activityType
                    let unID = loc.unicueID
                    let tl = loc
                    let loce = [loc.locations]
                    
                    for a in loce {
                        
                        let latitude = a[0]["Latitude"] as! CLLocationDegrees
                        let longitude = a[0]["Longitude"] as! CLLocationDegrees
                        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
                        let point = TrailsAnnotation(coordinate: self.coordinate) //
                        point.title = name
                        point.eta = desc
                        point.imageUrl = url!
                        point.actType = type
                        point.unicueId = unID
                        point.tr = tl
                        
                  self.theMap.addAnnotation(point)
                    }
                }
        
        segmentedControl.selectedSegmentIndex = 1
        
        setUpLocationManager()
        
        mapView.setUpMapView(view: theMap, delegate: self)
        mapView.zoomMap(val: 0.04, superVisor: manager, view: theMap)
        theMap.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 10)
        
    }
    
    
   // MARK -MKAnnotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is TrailsAnnotation){
            return nil
        }
        
        var annotationView = self.theMap.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
            annotationView?.tintColor = .blue
        }else{
            annotationView?.annotation = annotation
        }
        
        // Left Accessory
        let trailsAnnotation = annotation as! TrailsAnnotation

        let imView = UIImageView()
        getImage(trailsAnnotation.imageUrl!, imageView: imView)
        imView.frame = CGRect(x: 0,y:0,width: 50,height: 50)
        annotationView?.leftCalloutAccessoryView = imView
        
        // Right accessory view
        let image = UIImage(named: "Forward_000000_25")
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(image, for: UIControlState())
        annotationView?.rightCalloutAccessoryView = button
        
        
        let actName = trailsAnnotation.actType
        if actName == "Walk" {
            annotationView?.rightCalloutAccessoryView?.backgroundColor = walkColor()
        } else if actName == "Run" {
             annotationView?.rightCalloutAccessoryView?.backgroundColor = runColor()
        } else if actName == "Bike" {
             annotationView?.rightCalloutAccessoryView?.backgroundColor = bikeColor()
        } else if actName == "Hike" {
             annotationView?.rightCalloutAccessoryView?.backgroundColor = hikeColor()
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let a = view.annotation as! TrailsAnnotation
        testArr = [a.tr!]
       
        self.performSegue(withIdentifier: "SegMapToInfo", sender: self)
        
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if segue.identifier == "SegMapToInfo" {
        let dest = segue.destination as! CellOutletFromProfileVC
       
        dest.arr = testArr
        dest.vcId = "TracksMapVC"
        } else if segue.identifier == "filterMap" {
            let dest = segue.destination as! FilterVC
            dest.viewID = "TracksMapVC"
        }
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
    
    
    @IBAction func filterHitMap(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "filterMap", sender: self)
    }

}
