//
//  SingleActivityTitleView.swift
//  Trail Lab
//
//  Created by Nika on 7/18/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct SingleActivityTitleView: View {
    let activity: Activity
    
    var body: some View {
        VStack {
            HStack {
                Text("\(self.activity.start.localaizedDate)")
                    .font(.subheadline)
                Spacer()
            }
            HStack(alignment: .top) {
                Text("\(self.activity.title ?? self.activity.activityType.name())".capitalized)
                + Text(" \(self.activity.start.localizedStringTime) - \(self.activity.end.localizedStringTime)")
                Spacer()
            }
            .font(.headline)
        }
    }
}

struct SingleActivityTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SingleActivityTitleView(activity: MocActivity)
    }
}
