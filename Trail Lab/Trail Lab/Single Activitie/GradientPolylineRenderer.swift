//
//  GradientPolylineRenderer.swift
//  Trail Lab
//
//  Created by Nika on 7/16/20.
//  Copyright © 2020 nilka. All rights reserved.
//

import Foundation
import MapKit
import UIKit

struct RouteWaypoint {
    var location: CLLocation
    var color: UIColor
}

class GradientPolyline: MKPolyline {
    var colors: [CGColor]?
    let defaultColor = UIColor.gray.cgColor

    convenience init(waypoints: [RouteWaypoint]) {
        let coordinates = waypoints.map( { $0.location.coordinate } )
        self.init(coordinates: coordinates, count: coordinates.count)

        colors = waypoints.map({
            let color = $0.color
            return color.cgColor
        })
    }
    func getColor(for index: Int) -> CGColor {
        guard let colors = colors, index > 0 && index < colors.count else {
            return defaultColor
        }
        return colors[index]
    }
}

class GradientPolylineRenderer: MKPolylineRenderer {

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let boundingBox = self.path?.boundingBox,
            rect(for: mapRect).intersects(boundingBox) else { return }

        var prevColor: CGColor?
        var currentColor: CGColor?

        guard let polyLine = self.polyline as? GradientPolyline else { return }

        for index in 0...self.polyline.pointCount - 1{
            let point = self.point(for: self.polyline.points()[index])
            let path = CGMutablePath()

            currentColor = polyLine.getColor(for: index)

            if index == 0 {
                path.move(to: point)
            } else {
                let prevPoint = self.point(for: self.polyline.points()[index - 1])
                path.move(to: prevPoint)
                path.addLine(to: point)

                let colors = [prevColor!, currentColor!] as CFArray
                let baseWidth = self.lineWidth/(zoomScale * 0.6)

                context.saveGState()

                let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: [0, 1])

                context.setLineWidth(baseWidth)
                context.setLineJoin(.round)
                context.setLineCap(.round)
                context.addPath(path)
                context.replacePathWithStrokedPath()
                context.clip()
                let lastIndex = self.polyline.pointCount - 1
                if prevPoint != self.point(for: self.polyline.points()[lastIndex]) {
                    context.drawLinearGradient(gradient!, start: prevPoint, end: point, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
                }
                context.restoreGState()
            }
            prevColor = currentColor
        }
    }
}

