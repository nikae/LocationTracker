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
    
    
    func zoomMap(val: Double, superVisor: CLLocationManager, view: MKMapView ) {
        
        if let lat = superVisor.location?.coordinate.latitude, let long = superVisor.location?.coordinate.longitude {
        let span = MKCoordinateSpanMake(val, val)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        view.setRegion(region, animated: true)
        }
    }
    

}




