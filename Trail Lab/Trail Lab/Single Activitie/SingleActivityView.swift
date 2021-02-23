//
//  SingleActivityView.swift
//  Trail Lab
//
//  Created by Nika on 7/14/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

enum PagesToShow {
    case imagePicker
    case prepareShare
}

struct SingleActivityView: View {
    @ObservedObject var singleActivityViewHandler: SingleActivityViewHandler
    let mapViewHandler: MapViewHandler = MapViewHandler()
    let isNewActivity: Bool
    
    @State private var showingImagePicker = false
    @State private var showingShareView = false
    @State private var inputImage: UIImage?
    @State private var pagesToShow: PagesToShow = .imagePicker
    
    var color: Color {
        return singleActivityViewHandler.activity.activityType.color()
    }
    
    var isSpeedType: Bool {
        return singleActivityViewHandler.activity.activityType.hkValue() == .cycling
    }
    
    @State var expendMap: Bool = false
    @State var animateStats: Bool = false
    @State var openGraph: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                DismissIcon()
                    .padding(4)
                ScrollView {
                    SingleActivityTitleView(activity: singleActivityViewHandler.activity)
                        .padding(.top)
                        .padding(.horizontal)
                    mapView(proxy: proxy)
                        .environmentObject(self.mapViewHandler)
                    Spacer()
                    SingleActivityStatsView(activity: singleActivityViewHandler.activity)
                        .padding(.horizontal)
                        .background(Color(.systemBackground))
                        .animation(self.animateStats ? .easeOut : .none)
                        .onTapGesture {
                            openGraph.toggle()
                        }
                        .sheet(isPresented: $openGraph, content: {
                            if self.singleActivityViewHandler.showMap && !self.singleActivityViewHandler.altitudeList.isEmpty {
                                LinearChartView(data: self.singleActivityViewHandler.altitudeList,
                                                title: "Altitude",
                                                color:  self.singleActivityViewHandler.activity.activityType.color())
                            }
                        })
                    
                    shareView
                        .padding()
                }
                Spacer()
            }
            EmptyView()
                .sheet(isPresented: self.$showingShareView) {
                    ShareImageView(image: self.$inputImage, activity: singleActivityViewHandler.activity)
                        .environmentObject(ShareManager())
                }
        }
    }
    
    var shareView: some View {
        HStack {
            Button(action: {
                //    inputImage = nil
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
    
    func mapView(proxy: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            if self.singleActivityViewHandler.showMap {
                ActivityMapView(routeWaypoints: singleActivityViewHandler.routeWaypoint)
                    .cornerRadius(self.expendMap ? 0 : 12)
                    .frame(height: self.expendMap ? proxy.size.height - 130 : 200)
                    .padding(self.expendMap ? .top : .all)
                    .animation(.easeInOut)
                    .overlay(
                        mapTypeChoicesView(proxy: proxy)
                            .padding())
                    .animation(.easeOut)
                    .overlay(expendMapButton)
                    .onTapGesture {
                        self.animateStats = true
                        self.expendMap.toggle()
                    }
                
            } else {
                Text("No Location Data!")
                    .font(.headline)
                    .opacity(0.5)
                    .padding(.vertical, 50)
            }
        }
    }
    
    func mapTypeChoicesView(proxy: GeometryProxy) -> some View {
        VStack {
            Spacer()
            MapTypeChoices()
                .background(Color(UIColor.background.primary)
                                .opacity(0.8)
                                .cornerRadius(8))
                .frame(width: proxy.size.width - 100)
                .opacity(self.expendMap ? 1 : 0)
        }
    }
    
    
    var expendMapButton: some View {
        VStack {
            HStack {
                Button(action: {
                    self.animateStats = true
                    self.expendMap.toggle()
                },
                label: {
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
    }
    
    func loadImage() {
        guard inputImage != nil else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showingShareView.toggle()
        }
        // image = Image(uiImage: inputImage)
    }
}


struct SingleActivityView_Previews: PreviewProvider {
    static var previews: some View {
        SingleActivityView(singleActivityViewHandler: SingleActivityViewHandler(activity: MocActivity),
                           isNewActivity: true)
    }
}

let MocActivity = Activity(
    start: Date(),
    end: Date(),
    activityType: .walking,
    intervals: [])
