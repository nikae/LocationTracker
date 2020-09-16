//
//  SingleActivityView.swift
//  Trail Lab
//
//  Created by Nika on 7/14/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI


struct SingleActivityView: View {
    @ObservedObject var singleActivityViewHandler = SingleActivityViewHandler()
    let mapViewHandler: MapViewHandler = MapViewHandler()
    let activity: Activity
    let isNewActivity: Bool

    @State private var showingImagePicker = false
    @State private var showingShareView = false
    @State private var inputImage: UIImage?

    var color: Color {
        return activity.activityType.color()
    }

    var isSpeedType: Bool {
        return activity.activityType.hkValue() == .cycling
    }

    @State var routeWaypoint: [RouteWaypoint] = []
    @State var expendMap: Bool = false
    @State var animateStats: Bool = false

    var body: some View {
        GeometryReader { proxy in
            VStack {
                DismissIcon()
                ScrollView {
                    SingleActivityTitleView(activity: self.activity)
                        .padding(.top)
                        .padding(.horizontal)
                    ZStack(alignment: .bottom) {
                        if self.singleActivityViewHandler.showMap {
                            ActivityMapView(routeWaypoints: self.routeWaypoint)
                                .cornerRadius(self.expendMap ? 0 : 12)
                                .frame(height: self.expendMap ? proxy.size.height - 130 : 200)
                                .padding(self.expendMap ? .top : .all)
                                .animation(.easeInOut)
                                .onTapGesture {
                                    self.animateStats = true
                                    self.expendMap.toggle()
                            }

                            VStack {
                                HStack {
                                    Button(action: {
                                        self.animateStats = true
                                        self.expendMap.toggle()
                                    }, label: {
                                        Image(systemName: self.expendMap ? "rectangle.compress.vertical" : "rectangle.expand.vertical")
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .foregroundColor(Color(.label))
                                    })
                                    Spacer()
                                }
                                Spacer()
                            }
                            .animation(.linear)
                            .padding(self.expendMap ? .top : .all)
                            MapTypeChoices()
                                .background(Color(UIColor.background.primary)
                                    .opacity(0.8)
                                    .cornerRadius(8))
                                .frame(width:proxy.size.width - 100)
                                .animation(.easeOut)
                                .opacity(self.expendMap ? 1 : 0)
                                .padding()

                        } else {
                            Text("No Location Data!")
                                .font(.headline)
                                .opacity(0.5)
                                .padding(.vertical, 50)
                        }
                    }
                    .environmentObject(self.mapViewHandler)

                    Spacer()
                    SingleActivityStatsView(activity: self.activity)
                        .padding(.horizontal)
                        .background(Color(.systemBackground))
                        .animation(self.animateStats ? .easeOut : .none)
                    
                    if self.singleActivityViewHandler.showMap && !self.singleActivityViewHandler.altitudeList.isEmpty {
                        linearGraph(dataPoints: self.singleActivityViewHandler.altitudeList)
                    }

                    HStack {
                        Button(action: {
                            self.showingImagePicker.toggle()
                        }) {
                            ShareButton(text: "Share", color: self.color)
                        }
                        .padding(.top)
                        .sheet(isPresented: self.$showingImagePicker, onDismiss: self.loadImage) {
                            ImagePicker(image: self.$inputImage)
                        }
                    }
                }
                Spacer()
            }
            .sheet(isPresented: self.$showingShareView) {
                ShareImageView(image: self.inputImage)
            }

            .onAppear {
                self.getWayPointsForTheMap()
            }
        }
    }

    fileprivate func getWayPointsForTheMap() {
        self.singleActivityViewHandler.getWaypointsFromHK(
        activity: self.activity) { waypoints, altitudes in
            DispatchQueue.main.async {
                if let waypoints = waypoints {
                    self.routeWaypoint = waypoints
                    self.singleActivityViewHandler.showMap = true
                }
                //                    if let altitudes = altitudes {
                //                        self.singleActivityViewHandler.altitudeList = altitudes
                //                    }
            }
        }
    }

    func loadImage() {
        guard inputImage != nil else { return }
        showingShareView.toggle()
       // image = Image(uiImage: inputImage)
    }
}


struct SingleActivityView_Previews: PreviewProvider {
    static var previews: some View {
        SingleActivityView(
            activity: MocActivity,
            isNewActivity: true)
    }
}

let MocActivity = Activity(
    start: Date(),
    end: Date(),
    activityType: .walking,
    intervals: [])
