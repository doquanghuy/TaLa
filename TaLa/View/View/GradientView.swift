//
//  GradientView.swift
//  TaLa
//
//  Created by huydoquang on 1/21/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

fileprivate extension Direction {
    func gradientDirection() -> (start: CGPoint, end: CGPoint) {
        var start: CGPoint!
        var end: CGPoint!
        
        switch self {
        case .down:
            start = CGPoint(x: 0.5, y: 0.0)
            end = CGPoint(x: 0.5, y: 1.0)
        case .up:
            start = CGPoint(x: 0.5, y: 1.0)
            end = CGPoint(x: 0.5, y: 0.0)
        case .right:
            start = CGPoint(x: 0.0, y: 0.5)
            end = CGPoint(x: 1.0, y: 0.5)
        case .left:
            start = CGPoint(x: 1.0, y: 0.5)
            end = CGPoint(x: 0.0, y: 0.5)
        }
        return (start, end)
    }
}

extension UIView {
    func addGradientAnimation(colors: [UIColor], locations: [NSNumber], direction: Direction) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.flatMap {$0.cgColor}
        gradientLayer.locations = locations
        gradientLayer.frame = CGRect(
            x: 0.0,
            y: -bounds.size.height,
            width: bounds.size.width,
            height: 2 * bounds.size.height)
        gradientLayer.startPoint = direction.gradientDirection().start
        gradientLayer.endPoint = direction.gradientDirection().end
        
        let locationAnimations = CustomCABasicAnimation.animation(keyPath: "locations") {(finished, anim) in
            gradientLayer.removeFromSuperlayer()
        }
        locationAnimations.fromValue = [0.0, 0.25, 0.5]
        locationAnimations.toValue = [0.5, 0.75, 1.0]
        locationAnimations.duration = 2.0
        locationAnimations.repeatCount = 1
        gradientLayer.add(locationAnimations, forKey: "gradientAnimation")
        self.layer.masksToBounds = true
        self.layer.addSublayer(gradientLayer)
    }
}
