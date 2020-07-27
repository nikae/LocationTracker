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
    @EnvironmentObject var mapViewHandler: MapViewHandler
    @Binding var selectedTab: Int
    @GestureState var dragState = DragState.inactive
    @GestureState var testDrag = DragState.inactive
    @State var longPressinProgress: Bool = false
    @State var progress: Float = 0
    @State var openSingleActivityView: Bool = false

    func simple(sucsess: Bool) {
        let generator = UINotificationFeedbackGenerator()
        if sucsess {
        generator.notificationOccurred(.success)
        } else {
            generator.notificationOccurred(.warning)
        }
    }

    var body: some View {
        VStack {
            ZStack {
                workoutButton(background: activityHandler.selectedActivityType.color(),
                          imageName: activityHandler.activityState == .inactive ? activityHandler.selectedActivityType.imageName() : activityHandler.activityState == .active  ? "stop.fill" : "play.fill",
                          isSystemIcon: activityHandler.activityState != .inactive )

                if self.activityHandler.activityState != .inactive {
                    EndProgressBar(progress: $progress)
                }
            }
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
                    if self.activityHandler.activityState != .active {
                        self.activityHandler.startActivity()
                        self.activityHandler.activityButtonTitle = "Tap and Hold"
                        self.mapViewHandler.zoomToActive()
                    } else {
//                        self.activityHandler.pauseActivity()
//                        self.activityHandler.activityButtonTitle = "Resume"
//                        self.simple(sucsess: false)
                    }
                }
        }

        .onLongPressGesture(minimumDuration: 2, pressing: { inProgress in
            print("In progress: \(inProgress)!")
            self.longPressinProgress = inProgress
            withAnimation(.linear(duration: !inProgress ? 0.3 : 2)) {
                if self.activityHandler.activityState != .inactive {
                    self.progress = inProgress ? 1 : 0
                }
            }
        }) {
            print("Long pressed!")
            if self.activityHandler.activityState != .inactive {
                self.simple(sucsess: true)
                self.activityHandler.stopActivity()
                self.activityHandler.activityButtonTitle = "Start"
                self.openSingleActivityView.toggle()
                print("inactive")
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

