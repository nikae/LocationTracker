//
//  SlideCard.swift
//  Trail Lab
//
//  Created by Nika on 6/11/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct SlideCard<Content: View> : View {

    @EnvironmentObject var dragBottomSheetHandler: DragBottomSheetHandler
    @GestureState var dragState = DragState.inactive

    var content: () -> Content
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
                self.dragBottomSheetHandler.dragState = state
        }
        .onEnded(dragBottomSheetHandler.onDragEnded)

        return Group {
            self.content()
        }
        .frame(height: dragBottomSheetHandler.viewHeight)
        .background(Color.clear)
        .cornerRadius(22.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.4), radius: 10.0)
        .offset(y: dragBottomSheetHandler.isDragWindow() ? dragBottomSheetHandler.position + dragBottomSheetHandler.dragState.translation.height : dragBottomSheetHandler.position)
        .gesture(drag)
    }
}
