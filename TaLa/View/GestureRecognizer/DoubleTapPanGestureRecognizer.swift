//
//  EatLastGestureRecognizer.swift
//  TaLa
//
//  Created by huydoquang on 1/7/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class DoubleTapPanGestureRecognizer: UIGestureRecognizer {
    private let durationBetweenTwoTaps = 1.0
    private let durationBetweenSecondTapsWithDrag = 1.0
    private let durationBetweenTouchBeganAndTouchEnd = 0.5
    private let minSpaceMoving: CGFloat = 20.0
    private var firstStartTime: Date!
    private var secondStartTime: Date!
    private var startPanLocation: CGPoint!
    private var endPointLocation: CGPoint!
    private var panTime: Date!
    private var numberTaps = 0
    
    private var timer = Timer()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            self.state = .failed
            return
        }
        let now = Date()
        self.numberTaps += 1
        if self.numberTaps == 1 {
            self.firstStartTime = now
        } else if self.numberTaps == 2 && Date.duration(from: self.firstStartTime, to: now) <= self.durationBetweenTwoTaps {
            self.timer.invalidate()
            self.panTime = now
            self.state = .began
            guard let touch = touches.first else { return }
            self.startPanLocation = touch.location(in: self.view)
        } else {
            self.state = .failed
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        switch self.numberTaps {
        case 2:
            self.state = .changed
        default:
            guard let touch = touches.first else { return }
            self.endPointLocation = touch.location(in: self.view)
            guard self.startPanLocation != nil else { return }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        switch self.numberTaps {
        case 2:
            guard let touch = touches.first else { return }
            self.endPointLocation = touch.location(in: self.view)
            self.state = Math.distance(from: self.startPanLocation, to: self.endPointLocation) <= self.minSpaceMoving ? .failed : .recognized
        default:
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[weak self] (timer) in
                self?.state = .failed
                self?.timer.invalidate()
            })
            break
        }
    }
    
    override func reset() {
        super.reset()
        self.firstStartTime = nil
        self.secondStartTime = nil
        self.panTime = nil
        self.numberTaps = 0
    }
}
