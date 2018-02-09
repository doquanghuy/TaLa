//
//  SpotlightView.swift
//  TaLa
//
//  Created by huydoquang on 1/19/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class SpotlightView: UIView {
    var isSpotlight = false
    
    func makeSpotlight(holdWhenComplete: Bool = false) {
        guard !self.isSpotlight else { return }
        self.isSpotlight = true
        
        if holdWhenComplete {
            self.layer.backgroundColor = UIColor.splotlightColor.cgColor
        }
        
        let scale = CustomCABasicAnimation.animation(keyPath: "transform.scale")
        scale.fromValue = NSNumber(value: 1.0)
        scale.toValue = NSNumber(value: 1.5)
        
        let backgroundColorAnim = CustomCABasicAnimation.animation(keyPath: "backgroundColor")
        backgroundColorAnim.fromValue = self.layer.backgroundColor
        backgroundColorAnim.toValue = UIColor.splotlightColor.cgColor
        
        let group = CustomCAAnimationGroup.animation() {[weak self](finished, anim) in
            if !holdWhenComplete {
                self?.isSpotlight = false
            }
        }
        group.animations = [scale, backgroundColorAnim]
        group.duration = 0.25
        
        self.layer.add(group, forKey: "spotlightAnim")
    }
    
    func unMakeSpotlight(holdWhenComplete: Bool = false) {
        guard self.isSpotlight else { return }
        self.layer.removeAnimation(forKey: "spotlightAnim")
        self.isSpotlight = false
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
}
