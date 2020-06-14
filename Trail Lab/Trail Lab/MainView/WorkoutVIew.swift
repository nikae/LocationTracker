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
    @EnvironmentObject var activityHandler: ActivityHandler

    var body: some View {
        ZStack {
            AppBackground()
            MapView()
                .edgesIgnoringSafeArea(.all)
            SlideCard() {

                VStack {
                    HStack(spacing: 0) {

                        Button(action: {
                            withAnimation(.linear) {
                                self.activityHandler.selectedActivityType = .walking
                            }
                            Preferences.activityType = ActivityType.walking.rawValue

                        }, label: {
                            self.workoutButton(
                                withBorder: true,
                                background: Color(UIColor.SportColors.walk),
                                imageName: ActivityType.walking.imageName())
                        })
                            .frame(minWidth: 0, maxWidth: .infinity)
                        Button(action: {
                            withAnimation(.linear) {
                                self.activityHandler.selectedActivityType = .running
                            }
                            Preferences.activityType = ActivityType.running.rawValue
                        }, label: {
                            self.workoutButton(
                                withBorder: true,
                                background: Color(UIColor.SportColors.run),
                                imageName: ActivityType.running.imageName())
                        })
                            .frame(minWidth: 0, maxWidth: .infinity)
                        Button(action: {
                            withAnimation(.linear) {
                                self.activityHandler.selectedActivityType = .hiking
                            }
                            Preferences.activityType = ActivityType.hiking.rawValue
                        }, label: {
                            self.workoutButton(
                                withBorder: true,
                                background: Color(UIColor.SportColors.hike),
                                imageName: ActivityType.hiking.imageName())
                        })
                            .frame(minWidth: 0, maxWidth: .infinity)
                        Button(action: {
                            withAnimation(.linear) {
                                self.activityHandler.selectedActivityType = .biking
                            }
                            Preferences.activityType = ActivityType.biking.rawValue
                        }, label: {
                            self.workoutButton(
                                withBorder: true,
                                background: Color(UIColor.SportColors.bike),
                                imageName: ActivityType.biking.imageName())
                        })
                            .frame(minWidth: 0, maxWidth: .infinity)

                    }
                    .frame(height: 70)
                    .padding(.top, 60)
                    .padding(.horizontal)

                    Spacer()
                }
                .background(Color(UIColor.background.primary)
                .opacity(0.9))
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

