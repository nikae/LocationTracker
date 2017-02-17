//
//  color.swift
//  Trail Lab
//
//  Created by Nika on 11/28/16.
//  Copyright © 2016 Nika. All rights reserved.
//
import UIKit


//Colors For PolyLine

    
enum PolyLineColor {
        case red, red1, orange, orange1, yellow, yellow1, grin
        
        func color() -> UIColor {
            switch (self) {
            case .red:
                return UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.9)
            case .red1 :
                return UIColor(red: 255/255.0, green: 50/255.0, blue: 0/255.0, alpha: 0.9)
            case .orange :
                return UIColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 0.9)
            case .orange1 :
                return UIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 0.9)
            case .yellow :
                return UIColor(red: 255/255.0, green: 210/255.0, blue: 0/255.0, alpha: 0.9)
            case .yellow1 :
                return UIColor(red: 189/255.0, green: 222/255.0, blue: 0/255.0, alpha: 0.9)
            case .grin :
                return UIColor(red: 61/255.0, green: 229/255.0, blue: 0/255.0, alpha: 0.9)
            }
            
        }

    }
    
enum SportColors {
    case run, walk, hike, bike
    
    func color() -> UIColor {
        switch (self) {
        case .run:
            return UIColor(red: 254/255.0, green: 220/255.0, blue: 40/255.0, alpha: 1)
        case .walk :
            return UIColor(red: 255/255.0, green: 118/255.0, blue: 94/255.0, alpha: 1)
        case .hike :
            return UIColor(red: 147/255.0, green: 201/255.0, blue: 106/255.0, alpha: 1)
        case .bike :
            return UIColor(red: 100/255.0, green: 185/255.0, blue: 190/255.0, alpha: 1)
    }
}
}


var blueColor = UIColor(red: 0/255.0, green: 145/255.0, blue: 255/255.0, alpha: 1)








