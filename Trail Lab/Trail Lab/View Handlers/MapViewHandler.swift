//
//  MapViewHandler.swift
//  Trail Lab
//
//  Created by Nika on 6/15/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import MapKit

class MapViewHandler: NSObject, ObservableObject, MapViewDelegate, MKMapViewDelegate {

    @Published var mapType: MKMapType = .mutedStandard
    var oldMapType: MKMapType = .mutedStandard
    var locationManager = LocationManager.shared.locationManager
    let mapView = MKMapView(frame: UIScreen.main.bounds)

    override init() {
        super.init()
        mapView.delegate = self
    }

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

    func zoomToActive() {
        zoomMap(val: 0.01, superVisor: locationManager, view: mapView)
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

    func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {
        print("")
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)-> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        print("render called")
        return renderer
    }

    func updatePolyline(with location: [CLLocation]) {
        if (location.count > 3){
            let sourceIndex = location.count - 1
            let destinationIndex = location.count - 4
            let c1 = location[sourceIndex].coordinate
            let c2 = location[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            polyline.title = "polyline"
            mapView.addOverlay(polyline)
        }
    }
}
