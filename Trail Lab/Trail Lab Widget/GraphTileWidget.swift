//
//  GraphTileWidget.swift
//  Trail Lab
//
//  Created by Nika on 9/19/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct GraphTileWidget: View {
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        VStack {
            HStack {
                Text("Weekly Distance")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.headline)
                    .foregroundColor(Color(.label))
                Spacer()
            }
            GraphBarsWidget()
            if widgetFamily == .systemLarge {
                ColorGuide()
            }
        }
        .padding()
        .background(self.AppBackground())
    }
}

struct GraphTileWidget_Previews: PreviewProvider {
    static var previews: some View {
        GraphTileWidget()
    }
}
