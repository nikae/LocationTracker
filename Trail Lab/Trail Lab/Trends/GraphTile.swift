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
                Text("Activitys")
                    .font(.largeTitle)
                    .foregroundColor(Color(.label))
                Spacer()
            }
            GraphBars()
                .background(Color(UIColor.background.primary)
                    .shadow(radius: 5)
                    .cornerRadius(10))
        }
        .padding(.horizontal)
    }
}

struct GraphTile_Previews: PreviewProvider {
    static var previews: some View {
        GraphTile()
    }
}
