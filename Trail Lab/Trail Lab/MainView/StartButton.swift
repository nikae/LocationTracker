//
//  StartButton.swift
//  Trail Lab
//
//  Created by Nika on 6/11/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct StartButton: View {
    let width: CGFloat = 80
    @EnvironmentObject var dragBottomSheetHandler: DragBottomSheetHandler
    @EnvironmentObject var activityHandler: ActivityHandler
    @Binding var selectedTab: Int
    @GestureState var dragState = DragState.inactive
    @GestureState var testDrag = DragState.inactive

    var body: some View {
        VStack {
            workoutButton(background: activityHandler.selectedActivityType.color(),
                          imageName: activityHandler.selectedActivityType.imageName())
                .frame(width: width, height: width)
            Spacer()
        }
        .offset(y:dragBottomSheetHandler.isDragWindow() ?
            dragBottomSheetHandler.position - (self.width + (dragBottomSheetHandler.isSmallDevice ? 0 : 20)) + dragBottomSheetHandler.dragState.translation.height :
            dragBottomSheetHandler.position - (self.width + (dragBottomSheetHandler.isSmallDevice ? 0 : 20)))
            .onTapGesture {
                if self.selectedTab != 1 {
                    self.selectedTab = 1
                } else {
                    //TODO: START WORKOUT
                }
        }

        .gesture( self.selectedTab == 1 ?
            DragGesture()
                .updating($dragState) { drag, state, transaction in
                    state = .dragging(translation: drag.translation)
                    self.dragBottomSheetHandler.dragState = .dragging(translation: drag.translation)
                    self.dragBottomSheetHandler.isDragWindowAbove()
            }
            .onEnded(dragBottomSheetHandler.onDragEnded) : DragGesture().updating($testDrag) { _, _, _ in}
            .onEnded(dragBottomSheetHandler.onDragEndedTest))
    }
}

struct StartButton_Previews: PreviewProvider {
    static var previews: some View {
        StartButton(selectedTab: .constant(0))
    }
}

