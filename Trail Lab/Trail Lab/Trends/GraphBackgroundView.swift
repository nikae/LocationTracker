//
//  GraphBackgroundView.swift
//  Trail Lab
//
//  Created by Nika on 9/19/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct GraphBackgroundView: View {
    let maxHeight: CGFloat
    let showLess: Bool
    var body: some View {
        GeometryReader { reader in
            ForEach(0..<(showLess ? 4 : 5), id: \.self) { line in
                Group {
                    Path { path in
                        let y = self.tempLabelOffset(line, height: reader.size.height)
                        path.move(to: CGPoint(x: 40, y: y))
                        path.addLine(to: CGPoint(x: reader.size.width, y: y))
                    }.strokedPath(.init(lineWidth: 0.5, dash: [3, 3], dashPhase: 10))
                        .fill(line == 0 ? Color.clear : Color(.systemGray3).opacity(0.5))
                    if line > 0 {
                        Text("\(Meter(((self.maxHeight / (showLess ? 3 : 4)) * CGFloat(line)) - (self.maxHeight / 20) ).formatDistane())")
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
            line * (showLess ? 33 : 25),
            width: self.getHeight(height, range: 105))
    }
}

struct GraphBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        GraphBackgroundView(maxHeight: 3, showLess: false)
    }
}
