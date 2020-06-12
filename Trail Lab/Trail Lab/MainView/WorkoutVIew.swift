//
//  WorkoutVIew.swift
//  Trail Lab
//
//  Created by Nika on 6/9/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI
import MapKit
import UIKit

struct WorkoutVIew: View {

    @EnvironmentObject var dragBottomSheetHandler: DragBottomSheetHandler

    var body: some View {
        ZStack {
            AppBackground()
            MapView()
                .edgesIgnoringSafeArea(.all)
            SlideCard() {
                VStack {
                    Color(UIColor.background.primary)
                        .opacity(0.9)
                    Spacer()
                }
            }
            .environmentObject(dragBottomSheetHandler)

        }
    }
}

struct WorkoutVIew_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutVIew()
    }
}

extension View {
    func AppBackground() -> some View {
        return Color(UIColor.background.primary)
            .edgesIgnoringSafeArea(.all)
    }

    func AppBackgroundGeadient() -> some View {
        let topColor = Color(UIColor.Blue.primary)
        let bottomColor = Color(UIColor.Blue.primaryDark)
        return LinearGradient(
            gradient: Gradient(
                colors: [topColor, bottomColor]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading)
            .edgesIgnoringSafeArea(.all)
    }
}


struct MapView: UIViewRepresentable {

    var locationManager = CLLocationManager()
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }

    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}

