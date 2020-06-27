//
//  ImageExtensions.swift
//  Trail Lab
//
//  Created by Nika on 6/25/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import SwiftUI

extension Image {
    func resizeToFit() -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    func resizeToFill() -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
