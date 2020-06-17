//
//  Color.swift
//  Trail Lab
//
//  Created by Nika on 6/9/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

extension UIColor {

    struct background {
        static let primary = dynamicColor(
            light: .white,
            dark: UIColor(netHex: 0x1C1C1D))
        static let primaryDark = dynamicColor(
            light: .white,
            dark: UIColor(netHex: 0x050505))
        static let secondary =  dynamicColor(
            light: .white,
            dark: UIColor(netHex: 0x454547))
        static let accentColor =  dynamicColor(
                   light: UIColor(netHex: 0x454547),
                   dark: UIColor(netHex: 0x525254))
    }

    struct SportColors {
        static let run = UIColor(red: 254/255.0, green: 220/255.0, blue: 40/255.0, alpha: 1)
        static let walk = UIColor(red: 255/255.0, green: 118/255.0, blue: 94/255.0, alpha: 1)
        static let hike = UIColor(red: 147/255.0, green: 201/255.0, blue: 106/255.0, alpha: 1)
        static let bike = UIColor(red: 100/255.0, green: 185/255.0, blue: 190/255.0, alpha: 1)
    }
}

