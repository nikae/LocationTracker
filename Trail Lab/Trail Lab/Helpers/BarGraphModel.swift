//
//  BarGraphModel.swift
//  Trail Lab
//
//  Created by Nika on 9/19/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import SwiftUI

struct BarGraphModel {
    let id: UUID = UUID()
    let v: CGFloat
    let c: Gradient
    let day: String
}

struct BarGraphModelWidget: Codable {
    let id: UUID
    let v: CGFloat
    let c: [Int: CGFloat]
    let day: String

    static let sharedKey = "BarGraphModelWidget"
}

extension UserDefaults {
    static var shared: UserDefaults? {
        return UserDefaults(suiteName: "group.room.traillab.contents")
    }
}
