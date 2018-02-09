//
//  CustomSwipeGestureRecognizer.swift
//  TaLa
//
//  Created by huydoquang on 1/8/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

enum Direction {
    case left, right, up, down
    
    static func direction(from angel: Double) -> Direction {
        switch angel {
        case 45..<135:
            return .up
        case 135..<225:
            return .left
        case 225..<315:
            return .down
        default:
            return .right
        }
    }
}

enum Location {
    case topLeft, topRight, downLeft, downRight
    
    static func location(from angel: Double) -> Location {
        switch angel {
        case 0..<90:
            return .topRight
        case 90..<180:
            return .topLeft
        case 180..<270:
            return .downLeft
        default:
            return .downRight
        }
    }
    
    static func isRight(from angel: Double) -> Bool {
        let location = self.location(from: angel)
        return location == .downRight || location == .topRight
    }
}

protocol TranslateAndRotate {
    func translateAndRotate(sender: CustomSwipeGestureRecognizer, containerView: UIView, completion: ((CGPoint) -> Void)?)
}

class CustomSwipeGestureRecognizer: UIGestureRecognizer {
    private let minSpace: CGFloat = 20.0
    private let maxDuration: Double = 0.25
    private var startTime: Date!
    private var endTime: Date!
    private var startLocation: CGPoint!
    private var directions: [Direction] = [.up, .down, .left, .right]
    var direction: Direction!
    var endLocation: CGPoint!
    var angel: Double!
    
    var velocity: Double = 0.0

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            self.state = .failed
            return
        }
        self.startTime = Date()
        self.startLocation = touches.first?.location(in: self.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        self.endTime = Date()
        self.endLocation = touches.first?.location(in: self.view)
        guard Date.duration(from: self.startTime, to: self.endTime) <= maxDuration else {
            self.state = .failed
            return
        }
        guard Math.distance(from: self.startLocation, to: self.endLocation) >= minSpace else { return }
        self.velocity = Math.velocity(from: self.startTime, to: self.endTime, from: self.startLocation, to: self.endLocation)
        self.angel = Math.angel(from: self.startLocation, to: self.endLocation)
        self.direction = Direction.direction(from: self.angel)
        if !self.directions.contains(direction)  {
            self.state = .failed
        } else {
            self.state = .recognized
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.endTime = Date()
        self.endLocation = touches.first?.location(in: self.view)
        guard Date.duration(from: self.startTime, to: self.endTime) <= maxDuration else {
            self.state = .failed
            return
        }
        guard Math.distance(from: self.startLocation, to: self.endLocation) >= minSpace else {
            self.state = .failed
            return
        }
        self.velocity = Math.velocity(from: self.startTime, to: self.endTime, from: self.startLocation, to: self.endLocation)
        self.angel = Math.angel(from: self.startLocation, to: self.endLocation)
        self.direction = Direction.direction(from: self.angel)
        if !self.directions.contains(direction)  {
            self.state = .failed
        } else {
            self.state = .recognized
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
    }
    
    override func reset() {
        super.reset()
        self.startTime = nil
        self.endTime = nil
        self.startLocation = CGPoint.zero
        self.endLocation = CGPoint.zero
    }
}
