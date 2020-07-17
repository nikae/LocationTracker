//
//  ViewModifiers.swift
//  Trail Lab
//
//  Created by Nika on 6/25/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import SwiftUI


struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct appShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.4), radius: 10.0)
    }
}

struct noShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.clear, radius: 0)
    }
}
