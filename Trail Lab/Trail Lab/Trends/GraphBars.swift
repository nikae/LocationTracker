//
//  GraphBars.swift
//  Trail Lab
//
//  Created by Nika on 7/8/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

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
                .opacity(0.5)
            ZStack {

                HStack {
                    Spacer()
                    ForEach(self.historyViewHandler.barGraphModels, id: \.id) { height in
                        BarView(
                            height: self.calcHeight(maxH: self.macH, height: height.v),
                            gradient: height.c,
                            day: height.day,
                            showDays: true)
                            .frame(maxWidth: 30, maxHeight: 230)
                    }

                
                }
                .padding(.trailing)
                GraphBackgroundView(maxHeight: self.macH, showLess: false)
                .frame(height: 230)
            }
        }
        //.padding()
    }
    
    func calcHeight(maxH: CGFloat, height: CGFloat) -> CGFloat {
        return height / maxH
    }
}

struct BarsHeader: View {
    @EnvironmentObject var historyViewHandler: HistoryViewHandler
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                let date = self.historyViewHandler.getMonday(.previous,
                                                             for: self.historyViewHandler.selectedDateForDraphs)
                self.historyViewHandler.getWorkoutsForAWeek(for: date)
            }) {
                directionalButton(.previous)
            }

            Button(action: {
                 let date = self.historyViewHandler.getMonday(.current, for: Date())
                self.historyViewHandler.getWorkoutsForAWeek(for: date)
            }) {
                Text(historyViewHandler.dateTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .minimumScaleFactor(.leastNonzeroMagnitude)
                .frame(minWidth: 200, maxWidth: .infinity)
            }
            .padding(.horizontal)

            Button(action: {
                let date = self.historyViewHandler.getMonday(.next, for: self.historyViewHandler.selectedDateForDraphs)
                self.historyViewHandler.getWorkoutsForAWeek(for: date)
            }) {
                directionalButton(.next)
            }
            Spacer()
        }
        .foregroundColor(Color(.label))

    }
}


struct GraphBars_Previews: PreviewProvider {
    static var previews: some View {
        GraphBars()
    }
}
