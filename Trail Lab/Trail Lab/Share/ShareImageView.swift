//
//  ShareImageView.swift
//  Trail Lab
//
//  Created by Nika on 9/15/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import SwiftUI

struct ShareImageView: View {
    let image: UIImage?
    var body: some View {
        ZStack {
            if image != nil {
                Image(uiImage: image!)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 150, alignment: .center)
                    .padding()
                    .overlay(Text("WE MADE IT HERE")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(Color.white))
            }
        }
    }
}

struct ShareImageView_Previews: PreviewProvider {
    static var previews: some View {
        ShareImageView(image: nil)
    }
}
