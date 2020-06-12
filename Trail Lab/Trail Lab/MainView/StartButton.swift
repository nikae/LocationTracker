//
//  StartButton.swift
//  Trail Lab
//
//  Created by Nika on 6/11/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct StartButton: View {
    let width = UIScreen.main.bounds.width * 0.25
    @EnvironmentObject var dragBottomSheetHandler: DragBottomSheetHandler
    @Binding var selectedTab: Int
    @GestureState var dragState = DragState.inactive

    var body: some View {
        VStack {
            Circle()
                .foregroundColor(Color.yellow)

                .frame(width: self.width, height: self.width, alignment: .center)
            Spacer()
        }
        .offset(y:dragBottomSheetHandler.isDragWindow() ?
            dragBottomSheetHandler.position - (self.width + 8) + dragBottomSheetHandler.dragState.translation.height :
            dragBottomSheetHandler.position - (self.width + 8))
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
            }
            .onEnded(dragBottomSheetHandler.onDragEnded))
    }
}

struct StartButton_Previews: PreviewProvider {
    static var previews: some View {
        StartButton(selectedTab: .constant(0))
    }
}
