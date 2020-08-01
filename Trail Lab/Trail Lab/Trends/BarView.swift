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
    let gradient: Gradient
    let day: String
    @State var h: CGFloat = 0



    var body: some View {
            VStack {
                GeometryReader { proxy in
                    ZStack(alignment: .bottom){
                Capsule()
                    .foregroundColor(Color(UIColor.background.secondary))
                    .opacity(1)
                Capsule()
                    .fill(LinearGradient(
                        gradient: self.gradient,
                        startPoint: .bottom,
                        endPoint: .top))
                    .frame(height: proxy.size.height * self.h)
                    .animation(.easeOut)
                    .onAppear {
                        self.h = self.height
                }
                }
                }
                VStack {
                    Divider()
                    Text(self.day)
                        .font(.subheadline)
                }
                .frame(height: 30)

            .onDisappear {
                self.h = 0
            }
        }
    }
}
//
//struct BarView_Previews: PreviewProvider {
//    static var previews: some View {
//        HStack {
//            BarView(height: 1, colors: [.red, .red, .green, .blue], day: "M")
//                .padding()
//            BarView(height: 1, colors: [.red, .green], day: "T")
//                .padding()
//            BarView(height: 1, colors: [.red, .red, .yellow], day: "W")
//                .padding()
//        }
//        .padding()
//    }
//}
