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
    @Binding var selectedTab: Int
    @GestureState var dragState = DragState.inactive

    var body: some View {
        VStack {
            workoutButton(background: Color(UIColor.SportColors.bike),
                          imageName: "cycling")
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

        .gesture(
            DragGesture()
                .updating($dragState) { drag, state, transaction in
                    state = .dragging(translation: drag.translation)
                    self.dragBottomSheetHandler.dragState = .dragging(translation: drag.translation)
                    self.dragBottomSheetHandler.isDragWindowAbove() 
            }
            .onEnded(dragBottomSheetHandler.onDragEnded))
    }
}

struct StartButton_Previews: PreviewProvider {
    static var previews: some View {
        StartButton(selectedTab: .constant(0))
    }
}

extension View {
    func workoutButton(withBorder: Bool = false,
                background: Color = .blue,
                imageName: String = "")
        -> some View {
            return ZStack(alignment: .center) {
                Circle()
                .overlay(
                  Circle()
                    .stroke(withBorder ? Color.black : .clear ,lineWidth: 0.5)
                ).foregroundColor(background)

                Image(imageName)
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
                .padding(20)
            }
    }
}

