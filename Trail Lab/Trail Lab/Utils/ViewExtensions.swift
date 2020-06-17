//
//  ViewExtensions.swift
//  Trail Lab
//
//  Created by Nika on 6/16/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

//MARK: Background
extension View {
    func AppBackground() -> some View {
        return Color(UIColor.background.primary)
            .edgesIgnoringSafeArea(.all)
    }
}

//MARK: Button styles
extension View {
    func workoutButton(withBorder: Bool = false,
                       background: Color = .blue,
                       imageName: String = "") -> some View {
        return ZStack(alignment: .center) {
            Circle()
                .overlay(Circle()
                    .stroke(
                        withBorder ? Color.black : .clear ,
                        lineWidth: 0.5))
                .foregroundColor(background)

            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .padding(20)
        }
    }

    func mapButton(_ text: String, selected: Bool)  -> some View  {
        return selected ?
            Text(text)
                .underline()
                .lineLimit(1)
                .foregroundColor(Color(.label)) :
            Text(text)
                .lineLimit(1)
                .foregroundColor(Color(.label))
    }
}
