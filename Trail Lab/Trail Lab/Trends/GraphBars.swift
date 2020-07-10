//
//  GraphBars.swift
//  Trail Lab
//
//  Created by Nika on 7/8/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct BarGraphModel {
    let id: UUID = UUID()
    let v: CGFloat
    let c: [Color]
}

struct GraphBars: View {
    @EnvironmentObject var historyViewHandler: HistoryViewHandler

    var macH: CGFloat {
        var max: CGFloat = 0
        for i in historyViewHandler.barGraphModels {
            if i.v > max {
                max = i.v
            }
        }
        return max > 0 ? max : 1
    }

    var body: some View {
        VStack {
            BarsHeader()
            HStack {
                ForEach(historyViewHandler.barGraphModels, id: \.id) { height in
                    BarView(
                        height: self.calcHeight(maxH: self.macH, height: height.v),
                        colors: height.c)
                        .frame(maxWidth: 50, maxHeight: 200)
                }
            }
        }
        .padding(.horizontal)
    }
    
    func calcHeight(maxH: CGFloat, height: CGFloat) -> CGFloat {
        return height / maxH
    }
}

struct BarsHeader: View {
    @EnvironmentObject var historyViewHandler: HistoryViewHandler
    var body: some View {
        HStack {
            Button(action: {
                let date = self.historyViewHandler.getMonday(.previous)
                self.historyViewHandler.getWorkoutsForAWeek(for: date)
            }) {
                directionalButton(.previous)
            }
            Spacer()
            Button(action: {
                self.historyViewHandler.selectedDateForDraphs = Date()
                self.historyViewHandler.getWorkoutsForAWeek(for: self.historyViewHandler.selectedDateForDraphs)
            }) {
                Text(historyViewHandler.dateTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .minimumScaleFactor(.leastNonzeroMagnitude)
            }
            .padding(.horizontal)
            Spacer()
            Button(action: {
                let date = self.historyViewHandler.getMonday(.next)
                self.historyViewHandler.getWorkoutsForAWeek(for: date)
            }) {
                directionalButton(.next)
            }
        }
        .foregroundColor(Color(.label))
    }
}


struct GraphBars_Previews: PreviewProvider {
    static var previews: some View {
        GraphBars()
    }
}
