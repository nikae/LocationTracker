//
//  BarView.swift
//  Trail Lab
//
//  Created by Nika on 7/8/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct BarView: View {
    let height: CGFloat
    let colors: [Color]
    @State var h: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom){
                Capsule()
                    .foregroundColor(Color(UIColor.background.secondary))
                    .opacity(1)
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: self.colors),
                        startPoint: .bottom,
                        endPoint: .top))
                    .frame(height: proxy.size.height * self.h)
                    .animation(.easeOut)
                    .onAppear {
                        self.h = self.height
                }
            }
            .onDisappear {
                self.h = 0
            }

        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            BarView(height: 1, colors: [.red, .red, .green, .blue])
                .padding()
            BarView(height: 1, colors: [.red, .green])
                .padding()
            BarView(height: 1, colors: [.red, .red, .yellow])
                .padding()
        }
        .padding()
    }
}
