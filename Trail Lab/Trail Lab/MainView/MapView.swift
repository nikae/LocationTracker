//
//  MapView.swift
//  Trail Lab
//
//  Created by Nika on 6/16/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI
import MapKit
import UIKit

protocol MapViewDelegate: AnyObject {
    func updatePolyline(with location: [CLLocation])
}

struct MapView: UIViewRepresentable {
    @Binding var zoom: Double
    @EnvironmentObject var mapViewHandler: MapViewHandler
    @EnvironmentObject var activityHandler: ActivityHandler

    func makeUIView(context: Context) -> MKMapView {
        mapViewHandler.setupManager()
        mapViewHandler.mapView.showsUserLocation = true
        mapViewHandler.mapView.userTrackingMode = .follow
        mapViewHandler.mapView.mapType = mapViewHandler.mapType

        // create a 3D Camera
        if let lat = mapViewHandler.locationManager.manager.location?.coordinate.latitude,
           let long = mapViewHandler.locationManager.manager.location?.coordinate.longitude {
            let mapCamera = MKMapCamera()
            mapCamera.centerCoordinate = CLLocationCoordinate2D(
                latitude: lat,
                longitude: long)
            mapCamera.pitch = 45
            mapCamera.altitude = 100
            mapCamera.heading = 45

            // set the camera property
            mapViewHandler.mapView.camera = mapCamera
        }

        mapViewHandler.configureCompass(mapViewHandler.mapView)

        return mapViewHandler.mapView
    }


    func updateUIView(_ uiView: MKMapView, context: Context) {

        if activityHandler.activityState != .active {
            mapViewHandler.zoomMap(
                val: zoom,
                superVisor: mapViewHandler.locationManager.manager,
                view: uiView)
        }

        if mapViewHandler.mapType != mapViewHandler.oldMapType {
            uiView.mapType = mapViewHandler.mapType
           mapViewHandler.oldMapType = mapViewHandler.mapType
        }
    }
}
