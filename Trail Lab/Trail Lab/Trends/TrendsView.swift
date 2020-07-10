//
//  TrendsView.swift
//  Trail Lab
//
//  Created by Nika on 7/8/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct TrendsView: View {
    @EnvironmentObject var historyViewHandler: HistoryViewHandler
    var body: some View {
        ZStack {
            self.AppBackground()
            VStack {
           GraphTile()
                HStack {
                    Text("Goals")
                        .font(.headline)
                        .foregroundColor(Color(.label))
                    Spacer()
                }
                .padding()
                 Spacer()
            }
        }
        .onAppear {
            self.historyViewHandler.selectedDateForDraphs = Date()
            self.historyViewHandler.getWorkoutsForAWeek(for: self.historyViewHandler.selectedDateForDraphs)
        }
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
