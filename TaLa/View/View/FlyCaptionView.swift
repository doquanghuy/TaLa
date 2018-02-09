//
//  FlyCaptionView.swift
//  TaLa
//
//  Created by huydoquang on 1/17/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class FlyCaptionView: UIView {
    private static let contentSize = CGSize(width: 100.0, height: 20.0)

    static func add(on containerView: UIView, duration: Double, content: String?, center: CGPoint) {
        let contentLabel = UILabel(frame: CGRect(origin: .zero, size: contentSize))
        contentLabel.text = content
        contentLabel.center = center
        contentLabel.textAlignment = .center
        contentLabel.font = UIFont.defaultFont()
        contentLabel.textColor = .lightGray
        contentLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(contentLabel)
        
        let transition = CustomCABasicAnimation.animation(keyPath: "transform.translation")
        transition.fromValue = NSValue(cgPoint: .zero)
        transition.toValue = NSValue(cgPoint: CGPoint(x: 0.0, y: -200.0))
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotation.values = [0.0, -.pi/16.0, 0.0, .pi/16.0, 0.0]
        rotation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        
        let opacity = CustomCABasicAnimation.animation(keyPath: "opacity")
        opacity.fromValue = 1.0
        opacity.toValue = 0.0
        
        let group = CustomCAAnimationGroup.animation() {(finished, anim) in
            contentLabel.removeFromSuperview()
            contentLabel.layer.removeAnimation(forKey: "eatingViewContentAnimation")
        }
        group.duration = duration
        group.animations = [transition, rotation, opacity]
        group.fillMode = kCAFillModeBoth
        group.isRemovedOnCompletion = false
        
        contentLabel.layer.add(group, forKey: "eatingViewContentAnimation")
    }
}
