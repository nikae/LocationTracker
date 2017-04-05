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
    var uID: String!
    
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
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
    
    @IBOutlet weak var getTrailBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    let mapView = MyMapView()
    var coordinates1: [CLLocationCoordinate2D] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
  
        difLabel.adjustsFontSizeToFitWidth = true
        suitLabel.adjustsFontSizeToFitWidth = true
        whatToSeeLabel.adjustsFontSizeToFitWidth = true
        
         if (arr.count > 0) {
            
            if arr[0].difficulty.count > 0 {
                difLabel.text = "Difficulty: \(arr[0].difficulty.joined(separator: ", "))"
            } else {
                difLabel.text = "No difficulty data!"
            }
            
            if arr[0].suitability.count > 0 {
                suitLabel.text = "Suitability: \(arr[0].suitability.joined(separator: ", "))"
            } else {
                suitLabel.text = "No Suitability data!"
            }

            if arr[0].whatToSee.count > 0 {
                whatToSeeLabel.text = "What to see: \(arr[0].whatToSee.joined(separator: ", "))"
            } else {
                whatToSeeLabel.text = "No what to see data!"
            }
        
        print(arr[0].activityType)
        
        scrollView.delaysContentTouches = false
        //scrollView.isUserInteractionEnabled = false
        
        activeNameTF.text = arr[0].activityName
        distanceLabel.text = arr[0].distance
        timeLabel.text = arr[0].time
        paceLabel.text = arr[0].pace
        altitudeLabel.text = String(format: "%.2f ft", arr[0].altitudes.max()!)
                
           // if arr[0].pictureURL != "" {
        getImage(arr[0].pictureURL, imageView: activeImageView)
           // }
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
        
        decView1.clipsToBounds = true
        decView1.isUserInteractionEnabled = true
        decView1.layer.cornerRadius = decView1.frame.height/2
        
        let actName = self.arr[0].activityType
        var col = UIColor()
        
        if actName == "Walk" {
            col = walkColor()
        } else if actName == "Run" {
           col = runColor()
        } else if actName == "Bike" {
            col = bikeColor()
        } else if actName == "Hike" {
           col = hikeColor()
        }

        
        buttShape(but: getDirectionsBtn, color: hikeColor())
        buttonShedow(but: getDirectionsBtn)
        buttShape(but: doneBtn, color: bikeColor())
        buttonShedow(but: doneBtn)
        buttShape(but: getTrailBtn, color: col)
        buttonShedow(but: getTrailBtn)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if segue.identifier == "SegueactivDetiledVC" {
        let dest = segue.destination as! activDetiledVC
        dest.arrADVC = arr
        dest.vcId = vcId
        } else if segue.identifier == "GetTrailToVC" {
        let dest = segue.destination as! ViewController
        dest.passedLocations = arr[0].locations
        dest.passedTrailHeadName = arr[0].activityName
        } else {
        let imagedest = segue.destination as! FullImageVC
        imagedest.arrADVC = arr
        imagedest.vcId = vcId
            
        }
    }

    @IBAction func detailsHit(_ sender: UIButton) {
     // popUpActivityManager()
        self.performSegue(withIdentifier: "SegueactivDetiledVC", sender: self) //SegueactivDetiledVC
    }
    
    @IBAction func getDirectionsHit(_ sender: UIButton) {
        openMapForPlace()
    }
    
    @IBAction func getTrailHit(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GetTrailToVC", sender: self)
    }
    
  
    @IBAction func openImageHit(_ sender: UIButton) {
       self.performSegue(withIdentifier: "openImage", sender: self)
    }
    @IBAction func backToMyLocation(_ sender: Any) {
        //mapView.zoomMap(val: 0.010, superVisor: manager, view: theMap)
        //mapView.setUpMapView(view: theMap, delegate: self)
        let lat = coordinates1[0].latitude
        let long = coordinates1[0].longitude
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        theMap.setRegion(region, animated: true)
    }
  
}
