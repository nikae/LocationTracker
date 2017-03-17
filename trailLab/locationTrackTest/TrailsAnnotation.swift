//
//  TrailsAnnotation.swift
//  Trail Lab
//
//  Created by Nika on 3/17/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import MapKit

class TrailsAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageUrl: String?
    var eta: String?
    var actType: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
