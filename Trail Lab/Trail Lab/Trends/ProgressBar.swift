//
//  ProgressBar.swift
//  Trail Lab
//
//  Created by Nika on 7/20/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    @Binding var progressLabel: String
    let title: String


    var body: some View {
        VStack {
          ZStack {
              Circle()
                  .trim(from: 0, to: 0.7)
                  .stroke(LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.yellow, Color.red]),
                    startPoint: .leading,
                    endPoint: .trailing),
                          lineWidth: 20)
                  .opacity(0.3)
                  .foregroundColor(Color.red)
                  .rotationEffect(Angle(degrees: -215))

              Circle()
                  .trim(from: 0.0, to: CGFloat(min(self.progress * 0.7, 0.7)))
                .stroke(LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.yellow, Color.red]),
                    startPoint: .leading,
                    endPoint: .trailing),
                        lineWidth: 20)
                  .foregroundColor(Color.red)
                  .rotationEffect(Angle(degrees: -215))
                .animation(.linear)
            Text(progressLabel)
                .font(.system(.body, design: .default))
                .multilineTextAlignment(.center)
          }
            Text(title)
                .font(.system(.headline, design: .default))
                .padding(.top, -30)
//                .offset(y: -20)
        }
      }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: .constant(0.5), progressLabel: .constant("--"), title: "--")
    }
}
