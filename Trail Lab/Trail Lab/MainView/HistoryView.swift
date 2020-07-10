//
//  HistoryView.swift
//  Trail Lab
//
//  Created by Nika on 6/26/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyViewHandler: HistoryViewHandler
    var body: some View {
        ZStack {
            self.AppBackground()
            List {
                ForEach(historyViewHandler.activityList, id: \.id) { act in
                    VStack {
                        Text("\(act.start) \(act.activityType.name())")
                        // Text("\(act.start) \(act.activityType.name())")
                    }
                }
            }
        }
        .onAppear {
            self.historyViewHandler.getActivityList()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
