//
//  GraphTile.swift
//  Trail Lab
//
//  Created by Nika on 7/9/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct GraphTile: View {
    var body: some View {
        VStack {
            HStack {
            Text("Weekly Distance")
                .font(.headline)
                .foregroundColor(Color(.label))
                Spacer()
            }
            GraphBars()
                .background(Color(.clear)
                    .cornerRadius(10))
            ColorGuide()
        }
        .padding()
//        .padding(.bottom)
         .background(self.AppBackground())
    }
}

struct GraphTile_Previews: PreviewProvider {
    static var previews: some View {
        GraphTile()
    }
}


struct Test: View {
    let maxHeight: CGFloat
    var body: some View {
        GeometryReader { reader in
            ForEach(0..<5, id: \.self) { line in
                Group {
                    Path { path in
                        let y = self.tempLabelOffset(line, height: reader.size.height)
                        path.move(to: CGPoint(x: 40, y: y))
                        path.addLine(to: CGPoint(x: reader.size.width, y: y))
                    }.strokedPath(.init(lineWidth: 0.5, dash: [3, 3], dashPhase: 10))
                        .fill(line == 0 ? Color.clear : Color(.systemGray3).opacity(0.5))
                    if line > 0 {
                        Text("\(Meter(((self.maxHeight / 4) * CGFloat(line)) - (self.maxHeight / 20) ).formatDistane())")
                            .font(.system(size: 11))
                            .offset(x: 0, y: self.tempLabelOffset(line, height: reader.size.height) - 10)
                            .foregroundColor(Color(.systemGray2))
                            .frame(maxWidth: 40)
                    }
                }
            }
        }
    }

    func widthOffset(_ index: Int, width: CGFloat) -> CGFloat {
        CGFloat(index) * width
    }

    func heightOffset(_ effort: Int, height: CGFloat) -> CGFloat {
        let viewBottom  = height
        let topPadding = height * 0.05
        let viewHeight  = viewBottom - topPadding

        return (viewHeight * -CGFloat(effort) / 100.0)
    }

    func getHeight(_ height: CGFloat, range: Int) -> CGFloat {
        height / CGFloat(range)
    }

    func tempLabelOffset(_ line: Int, height: CGFloat) -> CGFloat {
        height - self.widthOffset(
            line * 25,
            width: self.getHeight(height, range: 105))
    }
}
