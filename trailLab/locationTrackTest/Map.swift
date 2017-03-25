//
//  Map.swift
//  Trail Lab
//
//  Created by Nika on 11/28/16.
//  Copyright © 2016 Nika. All rights reserved.
//

import UIKit
import CoreData
import HealthKit
import CoreLocation
import MapKit


struct MyMapView {
    func setUpMapView(view: MKMapView, delegate: MKMapViewDelegate) {
    view.delegate = delegate
    view.mapType = MKMapType.standard
    view.showsUserLocation = true
    view.isZoomEnabled = true
    view.showsScale = true
    view.showsCompass = true
    view.showsBuildings = true
    }
    
    //NEEDS ERROR HANDLING
    func zoomMap(val: Double, superVisor: CLLocationManager, view: MKMapView ) {
        let lat = superVisor.location?.coordinate.latitude ?? 42.345573 //ForNOW Needs error handling
        let long = superVisor.location?.coordinate.longitude ??  -71.098326  //ForNOW Needs error handling
        let span = MKCoordinateSpanMake(val, val)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        view.setRegion(region, animated: true)
        
    }
    
    

}




