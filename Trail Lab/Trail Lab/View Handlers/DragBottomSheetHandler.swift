//
//  DragBottomSheetHandler.swift
//  Trail Lab
//
//  Created by Nika on 6/11/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import SwiftUI

enum CardPosition: CGFloat {
    case top = 100
    case middle = 500
    case bottom = 850
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }

    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

class DragBottomSheetHandler: ObservableObject {

    @Published var position: CGFloat = .zero
    @Published var dragState: DragState = DragState.inactive
    @Published var zoom: Double = 0.075
    @Published var showMapTypes: Bool = false

    var positionBelow: CGFloat = .zero
    var positionAbove: CGFloat = .zero
    var viewHeight: CGFloat = .zero
    var isSmallDevice: Bool = false

    func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let positionAbove = self.positionAbove
        let positionBelow = self.positionBelow

        withAnimation(.interpolatingSpring(
            stiffness: 300.0,
            damping: 30.0,
            initialVelocity: 10.0)) {
                if verticalDirection > 0 {
                    self.position = positionBelow
                    zoom = 0.075
                    showMapTypes = false
                } else {
                    self.position = positionAbove
                     zoom = 0.15
                }
        }
    }

    func onDragEndedTest(drag: DragGesture.Value) {
        //
    }

    func isDragWindow() -> (Bool) {
        return position + dragState.translation.height >= positionAbove &&
            position + dragState.translation.height <= positionBelow
    }

    func isDragWindowAbove() {
        if position + dragState.translation.height < positionAbove && position != positionAbove {
            position = positionAbove
        } else if position + dragState.translation.height > positionBelow && position != positionBelow  {
            position = positionBelow
        }
    }
    
}
