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

