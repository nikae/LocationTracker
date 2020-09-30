//
//  GraphBarsWidget.swift
//  Trail Lab
//
//  Created by Nika on 9/19/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct GraphBarsWidget: View {
    @Environment(\.widgetFamily) private var widgetFamily

    //Temp data
    var barGraphModels: [BarGraphModel]

    var macH: CGFloat {
        var max: CGFloat = 0
        for i in barGraphModels {
            if i.v > max {
                max = i.v
            }
        }
        return max > 0 ? max : 1
    }

    var body: some View {
        VStack {
            if widgetFamily == .systemLarge {
                HStack {
                    Spacer()
                    Text(Date().week().title)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .minimumScaleFactor(.leastNonzeroMagnitude)
                        .font(.subheadline)
                    Spacer()
                }.padding(4)
            }
            ZStack {

                HStack {
                    ForEach(self.barGraphModels, id: \.id) { height in
                        BarView(
                            height: self.calcHeight(maxH: self.macH, height: height.v),
                            gradient: height.c,
                            day: height.day,
                            showDays: widgetFamily == .systemLarge)
                            .frame(maxHeight: 230)
                    }
                }
                .padding(.leading, widgetFamily == .systemSmall ? 0 : 45)
                .padding(.trailing, widgetFamily == .systemSmall ? 0 : 5)
                if widgetFamily != .systemSmall {
                    GraphBackgroundView(maxHeight: self.macH, showLess: widgetFamily == .systemMedium)
                        .frame(maxHeight: 230)
                }
            }
        }
    }

    func calcHeight(maxH: CGFloat, height: CGFloat) -> CGFloat {
        return height / maxH
    }
}

struct GraphBarsWidget_Previews: PreviewProvider {
    static var previews: some View {
        GraphBarsWidget(barGraphModels: [])
    }
}
