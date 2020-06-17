//
//  MapViewHandler.swift
//  Trail Lab
//
//  Created by Nika on 6/15/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import MapKit

class MapViewHandler: ObservableObject {
    @Published var mapType: MKMapType = .mutedStandard
    var oldMapType: MKMapType = .mutedStandard
    var locationManager = CLLocationManager()
    let mapView = MKMapView(frame: UIScreen.main.bounds)

    func setupManager() {
           let status = CLLocationManager.authorizationStatus()
           switch status {
           case .notDetermined, .denied:
                    locationManager.requestWhenInUseAuthorization()
                  locationManager.requestAlwaysAuthorization()
           default:
               print(status)
           }
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
       }



    func zoomMap(val: Double, superVisor: CLLocationManager? = nil, view: MKMapView) {

          if let lat = superVisor?.location?.coordinate.latitude,
              let long = superVisor?.location?.coordinate.longitude {
              let span = MKCoordinateSpan(latitudeDelta: val, longitudeDelta: val)
              let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
              view.setRegion(region, animated: true)
          }
      }

    func configureCompass(_ mapView: MKMapView) {
        mapView.showsCompass = false
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.frame.origin = CGPoint(x: 20, y: 100)
        compassButton.compassVisibility = .adaptive
        mapView.addSubview(compassButton)

        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(
            equalTo: mapView.trailingAnchor,
            constant: -20)
            .isActive = true
        compassButton.topAnchor.constraint(
            equalTo: mapView.topAnchor,
            constant: 100).isActive = true
    }
}
