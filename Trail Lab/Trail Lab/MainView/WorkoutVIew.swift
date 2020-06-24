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
        ZStack(alignment: .top) {
            AppBackground()

            MapView(zoom: $dragBottomSheetHandler.zoom)
                .edgesIgnoringSafeArea(.bottom)
            SlideCard() {
               BottomCard()
                .background(Color(UIColor.background.primary)
                .opacity(0.9))
            }

            ActivityStatsView()
                .padding(.horizontal)
                .aspectRatio(2, contentMode: .fit)
                .offset(y: activityHandler.activityState == .inactive ? -300 : 60)

        }
    }
}

struct WorkoutVIew_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutVIew()
    }
}


