//
//  ActivityMapView.swift
//  Trail Lab
//
//  Created by Nika on 7/14/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit

struct ActivityMapView: UIViewRepresentable {
    var mapView = MKMapView()
    @EnvironmentObject var mapViewHandler: MapViewHandler

    var routeWaypoints: [RouteWaypoint]

    func makeUIView(context: Context) -> MKMapView {
        mapView.isScrollEnabled = true
        mapView.delegate = context.coordinator
        mapView.showsBuildings = true
        mapViewHandler.mapView.mapType = mapViewHandler.mapType
        return mapView
    }

    func addPolylineToMap() {
        let runRoute = GradientPolyline(waypoints: self.routeWaypoints)

        var topLeftCoord = CLLocationCoordinate2D.init(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D.init(latitude: 90, longitude: -180)

        for point in self.routeWaypoints {
            let loc = point.location
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, loc.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, loc.coordinate.latitude)

            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, loc.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, loc.coordinate.latitude)
        }
        let lateralSpan = fabs(topLeftCoord.latitude - bottomRightCoord.latitude)
        let longitudinalSpan = fabs(bottomRightCoord.longitude - topLeftCoord.longitude)

        let center = CLLocationCoordinate2D.init(latitude: topLeftCoord.latitude - lateralSpan * 0.4,
                                                 longitude: topLeftCoord.longitude + longitudinalSpan * 0.5)

        let span = MKCoordinateSpan.init(latitudeDelta: lateralSpan * 1.5, longitudeDelta: longitudinalSpan * 1.3)

        var region = MKCoordinateRegion.init(center: center, span: span);


        region = self.mapView.regionThatFits(region)

        self.mapView.setRegion(region, animated: true)
        self.mapView.addOverlay(runRoute)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {

        DispatchQueue.main.async {
            if uiView.overlays.count > 0 {return}
            if let firstLoc = self.routeWaypoints.first?.location {
                let annotation = MKPointAnnotation()
                let lat = firstLoc.coordinate.latitude
                let long = firstLoc.coordinate.longitude
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude:  long)
                uiView.addAnnotation(annotation)
            }
            if let lastLoc = self.routeWaypoints.last?.location {
                let annotation = MKPointAnnotation()
                let lat = lastLoc.coordinate.latitude
                let long = lastLoc.coordinate.longitude
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude:  long)
                uiView.addAnnotation(annotation)
            }
            self.addPolylineToMap()

        }

        if mapViewHandler.mapType != mapViewHandler.oldMapType {
                  uiView.mapType = mapViewHandler.mapType
                 mapViewHandler.oldMapType = mapViewHandler.mapType
              }
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ActivityMapView

        init(_ parent: ActivityMapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            //print(mapView.centerCoordinate)
        }

        func makeUIView(context: Context) -> MKMapView {
            let map = MKMapView()
            map.delegate = context.coordinator
            return map
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            guard let lastLocation = parent.routeWaypoints.last?.location else{
                return nil
            }
            if annotation.coordinate.latitude == lastLocation.coordinate.latitude && annotation.coordinate.longitude == lastLocation.coordinate.longitude{
                annotationView.pinTintColor = .green
            }
            else{
                annotationView.pinTintColor = .red

            }

            return annotationView
        }


        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is GradientPolyline {
                let polyLineRender = GradientPolylineRenderer(overlay: overlay)
                polyLineRender.lineWidth = 7
                return polyLineRender

            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

