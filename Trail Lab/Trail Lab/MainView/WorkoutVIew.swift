//
//  WorkoutVIew.swift
//  Trail Lab
//
//  Created by Nika on 6/9/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct WorkoutVIew: View {

    @EnvironmentObject var dragBottomSheetHandler: DragBottomSheetHandler
    @EnvironmentObject var activityHandler: ActivityHandler
    @EnvironmentObject var mapViewHandler: MapViewHandler 

    var body: some View {
        ZStack {
            AppBackground()
            MapView(zoom: $dragBottomSheetHandler.zoom)
            .environmentObject(self.mapViewHandler)
                .edgesIgnoringSafeArea(.bottom)
            SlideCard() {
               BottomCard()
                .environmentObject(self.dragBottomSheetHandler)
                .environmentObject(self.activityHandler)
                .environmentObject(self.mapViewHandler)
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


