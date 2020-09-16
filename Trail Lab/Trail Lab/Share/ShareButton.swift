//
//  ShareButton.swift
//  Trail Lab
//
//  Created by Nika on 9/15/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ShareButton: View {
    let text: String
    let color: Color
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            Spacer()
        }
        .background(self.color.cornerRadius(8))
        .padding()
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton(text: "Text", color: .red)
    }
}
