//
//  Ultil.swift
//  TaLa
//
//  Created by huydoquang on 1/8/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

struct Math {
    static func velocity(from startTime: Date, to endTime: Date, from startLocation: CGPoint, to endLocation: CGPoint) -> Double {
        let s = Double(self.distance(from: startLocation, to: endLocation))
        let t = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
        return s / t
    }
    
    static func angel(from startPoint: CGPoint, to endPoint: CGPoint) -> Double {
        let originPoint = CGPoint(x: endPoint.x - startPoint.x, y: -endPoint.y + startPoint.y)
        let bearingRadians = atan2f(Float(originPoint.y), Float(originPoint.x))
        var bearingDegrees = Double(bearingRadians) * (180.0 / Double.pi)
        bearingDegrees = bearingDegrees > 0.0 ? bearingDegrees : (360 + bearingDegrees)
        return bearingDegrees
    }
    
    static func distance(from startLocation: CGPoint, to endLocation: CGPoint) -> CGFloat {
        return sqrt(pow(endLocation.x - startLocation.x, 2) + pow(endLocation.y - startLocation.y, 2))
    }
    
    static func destinationPoint(angel: Double, and startPoint: CGPoint, on containerView: UIView) -> CGPoint? {
        let a = CGFloat(tan(angel))
        let leftIntersection = CGPoint(x: 0.0, y: -a * startPoint.x - startPoint.y)
        let rightIntersection = CGPoint(x: containerView.bounds.width, y: a * (containerView.bounds.width - startPoint.x) - startPoint.y)
        let topIntersection = CGPoint(x: startPoint.x + startPoint.y / a, y: 0.0)
        let bottomIntersection = CGPoint(x: startPoint.x + (-containerView.bounds.height + startPoint.y) / a, y: -containerView.bounds.height)
        var intersections = [topIntersection, leftIntersection, bottomIntersection, rightIntersection]
            .filter {$0.x >= 0.0 && $0.x <= containerView.bounds.width && $0.y <= 0.0 && $0.y >= -containerView.bounds.height}
        intersections = intersections.flatMap {CGPoint(x: $0.x, y: $0.y <= 0 ? -$0.y : $0.y)}
        
        switch Location.location(from: angel * 180.0 / Double.pi) {
        case .downLeft:
            return intersections.filter {$0.x <= startPoint.x && $0.y >= startPoint.y}.first
        case .downRight:
            return intersections.filter {$0.x >= startPoint.x && $0.y >= startPoint.y}.first
        case .topLeft:
            return intersections.filter {$0.x <= startPoint.x && $0.y <= startPoint.y}.first
        default:
            return intersections.filter {$0.x >= startPoint.x && $0.y <= startPoint.y}.first
        }
    }
}
