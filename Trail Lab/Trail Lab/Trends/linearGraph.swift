//
//  linearGraph.swift
//  Trail Lab
//
//  Created by Nika on 7/18/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct linearGraph: View {
    @State var on = false
    var dataPoints: [CGFloat]

    var body: some View {
        LineGraph(dataPoints: dataPoints)
            .trim(to: on ? 1 : 0)
            .stroke(Color.red, lineWidth: 2)
            .aspectRatio(16/9, contentMode: .fit)
            .border(Color.gray, width: 1)
            .padding()
            .onAppear {
                    self.on.toggle()
        }
    } 
}

struct linearGraph_Previews: PreviewProvider {
    static var previews: some View {
        linearGraph(dataPoints: [2.4, 3.5])
    }
}

struct LineGraph: Shape {
   var dataPoints: [CGFloat]

    var max: CGFloat {
        return dataPoints.max() ?? 1
    }

    func path(in rect: CGRect) -> Path {
        func point(at ix: Int) -> CGPoint {
            let point = (dataPoints[ix] / max)
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }

        return Path { p in
            guard dataPoints.count > 1 else { return }
            let start = (dataPoints[0] / max)
            p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
            for idx in dataPoints.indices {
                p.addLine(to: point(at: idx))
            }
        }
    }
}

