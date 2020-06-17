//
//  BottomCard.swift
//  Trail Lab
//
//  Created by Nika on 6/15/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct BottomCard: View {
    @EnvironmentObject var dragBottomSheetHandler: DragBottomSheetHandler
    @EnvironmentObject var activityHandler: ActivityHandler
    @EnvironmentObject var mapViewHandler: MapViewHandler

    var body: some View {
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

            Divider()
                .padding(.top)
                .padding(.horizontal)

            GeometryReader { proxy in
                HStack {
                    Button(action: {
                        withAnimation(.linear) {
                            self.dragBottomSheetHandler.showMapTypes.toggle()
                        }
                    }) {
                        Image(systemName: "square.stack.3d.up.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 30, height: 30, alignment: .center)


                    MapTypeChoices()
                        .frame(width: self.dragBottomSheetHandler.showMapTypes ? proxy.size.width - 100 : .zero)
                        .environmentObject(self.mapViewHandler)


                    Button(action: {
                        self.dragBottomSheetHandler.zoom = 0.15
                    }) {
                        Image(systemName: "location.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 30, height: 30, alignment: .center)


                    Spacer()
                }
                .foregroundColor(Color(UIColor.background.accentColor))
                .frame(height: 50)
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}

struct BottomCard_Previews: PreviewProvider {
    static var previews: some View {
        BottomCard()
    }
}

struct MapTypeChoices: View {
    @EnvironmentObject var mapViewHandler: MapViewHandler
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {

                Button(action: {
                    self.mapViewHandler.mapType = .standard
                }, label: {
                    mapButton("Standard", selected: self.mapViewHandler.mapType == .standard)
                })
                Button(action: {
                    self.mapViewHandler.mapType = .mutedStandard
                }, label: {
                    mapButton("Standard Muted", selected: self.mapViewHandler.mapType == .mutedStandard)
                })
                Button(action: {
                    self.mapViewHandler.mapType = .hybrid
                }, label: {
                    mapButton("Hybrid", selected:  self.mapViewHandler.mapType == .hybrid)
                })
                Button(action: {
                    self.mapViewHandler.mapType = .hybridFlyover
                }, label: {
                    mapButton("Hybrid 3D", selected: self.mapViewHandler.mapType == .hybridFlyover)
                })
                Button(action: {
                    self.mapViewHandler.mapType = .satellite
                }, label: {
                    mapButton("Satellite", selected: self.mapViewHandler.mapType == .satellite)
                })
                Button(action: {
                    self.mapViewHandler.mapType = .satelliteFlyover
                }, label: {
                    mapButton("Satellite 3D", selected:  self.mapViewHandler.mapType == .satelliteFlyover)
                })
            }
            .frame(height: 70)
            .padding(.horizontal)
        }
    }
}
