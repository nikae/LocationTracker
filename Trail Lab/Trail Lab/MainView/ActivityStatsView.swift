//
//  ActivityStatsView.swift
//  Trail Lab
//
//  Created by Nika on 6/16/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ActivityStatsView: View {
    var body: some View {
        ZStack {
            AppBackground()
                .cornerRadius(12)
        }
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.4), radius: 10.0)
    }
}

struct ActivityStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityStatsView()
    }
}
