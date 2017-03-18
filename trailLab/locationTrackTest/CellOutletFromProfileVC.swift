//
//  CellOutletFromProfileVC.swift
//  Trail Lab
//
//  Created by Nika on 3/10/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import CoreLocation
import Firebase

class CellOutletFromProfileVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    var arr: [Trail] = []
    var vcId: String!
    
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    @IBOutlet weak var decView1: UIView!
    var manager: CLLocationManager!
    
    @IBOutlet weak var activeNameTF: UITextField!
    
    @IBOutlet weak var activeImageView: UIImageView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var infoTV: UITextView!
    @IBOutlet weak var difLabel: UILabel!
    @IBOutlet weak var suitLabel: UILabel!
    @IBOutlet weak var whatToSeeLabel: UILabel!
    
    @IBOutlet weak var getDirectionsBtn: UIButton!
    
    
    let mapView = MyMapView()
    var coordinates1: [CLLocationCoordinate2D] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if (arr.count > 0) {
        
        print(arr[0].activityType)
        
        scrollView.delaysContentTouches = false
        
        activeNameTF.text = arr[0].activityName
        distanceLabel.text = arr[0].distance
        timeLabel.text = arr[0].time
        paceLabel.text = String(format: "%.2f ft", arr[0].pace.max()!)
        altitudeLabel.text = String(format: "%.2f ft", arr[0].altitudes.max()!)
        infoTV.text = arr[0].description
        
        getImage(arr[0].pictureURL, imageView: activeImageView)
        
         for loc in arr {
            let loce = loc.locations
            
            for a in loce {
               let latitude = a["Latitude"] as! CLLocationDegrees
                let longitude = a["Longitude"] as! CLLocationDegrees
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

                coordinates1.append(coordinate)
                
                let polyline = MKPolyline(coordinates: &coordinates1, count: coordinates1.count)
                
                self.theMap.add(polyline)

            }
            
        }
        
  
        setUpLocationManager()
       
        mapView.setUpMapView(view: theMap, delegate: self)
        let lat = coordinates1[0].latitude
        let long = coordinates1[0].longitude
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        theMap.setRegion(region, animated: true)
        theMap.showsUserLocation = false
        theMap.showsScale = false
        theMap.layoutMargins = UIEdgeInsets(top: 120, left: 0, bottom: 20, right: 10)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //does not work
        UIApplication.shared.isStatusBarHidden = true
        
        decView1.clipsToBounds = true
        decView1.isUserInteractionEnabled = true
        decView1.layer.cornerRadius = decView1.frame.height/2
        
        getDirectionsBtn.clipsToBounds = true
        getDirectionsBtn.layer.cornerRadius = getDirectionsBtn.frame.height/2


    }
    

    
  //MARK -Get Directions
    func openMapForPlace() {
   
        let regionDistance:CLLocationDistance = 10000
        let coordinatesGD = coordinates1[0]
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinatesGD, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        
        let placemark = MKPlacemark(coordinate: coordinatesGD, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = arr[0].activityName
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    //MARK -actions under scrollview
    func gestureRecognizer(_ shouldReceivegestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if (scrollView.superview != nil) {
    if ((touch.view?.isDescendant(of: scrollView)) != nil) { return false }
    }
    return true
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
        let actName = self.arr[0].activityType
        
        if actName == "Walk" {
            polylineRenderer.strokeColor = walkColor()
        } else if actName == "Run" {
            polylineRenderer.strokeColor = runColor()
        } else if actName == "Bike" {
            polylineRenderer.strokeColor = bikeColor()
        } else if actName == "Hike" {
            polylineRenderer.strokeColor = hikeColor()
        }
       
       // polylineRenderer.strokeColor = .black
        polylineRenderer.lineWidth = 5
        return polylineRenderer
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func swipeUpHit(_ sender: UISwipeGestureRecognizer) {
        //NEED TO CANCEL
    }

    
    @IBAction func removeNoNeedData(_ sender: UIButton) {
        arr.removeAll()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if vcId == "TracksVC"  {
            let controller = storyboard.instantiateViewController(withIdentifier: vcId) as! TracksVC
            self.present(controller, animated: false, completion: nil)
        } else if vcId == "TracksMapVC" {
                let controller = storyboard.instantiateViewController(withIdentifier: vcId) as! TracksMapVC
                self.present(controller, animated: false, completion: nil)
            } else if vcId == "ProfileVC" {
                let controller = storyboard.instantiateViewController(withIdentifier: vcId) as! ProfileVC
                self.present(controller, animated: false, completion: nil)
            }
    }

    var launchBool: Bool = false {
        didSet {
            if launchBool == true {
                self.scrollView.isUserInteractionEnabled = true
            } else {
                self.scrollView.isUserInteractionEnabled = false
            }
        }
    }
    
    @IBAction func ViewTapped(_ sender: UITapGestureRecognizer) {
        launchBool = !launchBool
    }

    func popUpActivityManager() {
        // PopUp to Save
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activDetiledVC") as! activDetiledVC
        self.addChildViewController(popUp)
        popUp.view.frame = self.view.frame
        self.view.addSubview(popUp.view)
        popUp.didMove(toParentViewController: self)
        
    }

    @IBAction func detailsHit(_ sender: UIButton) {
      popUpActivityManager()
        print("yasss!!")
    }
    
    @IBAction func getDirectionsHit(_ sender: UIButton) {
        openMapForPlace()
    }
  
  
}
