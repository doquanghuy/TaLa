//
//  Ext+CAAnimation.swift
//  TaLa
//
//  Created by huydoquang on 1/14/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class CustomCABasicAnimation: CABasicAnimation, CAAnimationDelegate {
    private var completion: ((_ finished: Bool, _ anim: CAAnimation) -> Void)?
    private var preparing: ((_ anim: CAAnimation) -> Void)?
    
    static func animation(keyPath: String?, preparing: ((_ anim: CAAnimation) -> Void)? = nil, completion: ((_ finished: Bool, _ anim: CAAnimation) -> Void)? = nil) -> CABasicAnimation {
        let animation = CustomCABasicAnimation(keyPath: keyPath)
        animation.delegate = animation
        animation.completion = completion
        animation.preparing = preparing
        return animation
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        preparing?(anim)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion?(flag, anim)
    }
}

class CustomCAAnimationGroup: CAAnimationGroup, CAAnimationDelegate {
    private var completion: ((_ finished: Bool, _ anim: CAAnimation) -> Void)?
    private var preparing: ((_ anim: CAAnimation) -> Void)?
    
    static func animation(preparing: ((_ anim: CAAnimation) -> Void)? = nil, completion: ((_ finished: Bool, _ anim: CAAnimation) -> Void)? = nil) -> CAAnimationGroup {
        let animation = CustomCAAnimationGroup()
        animation.delegate = animation
        animation.completion = completion
        animation.preparing = preparing
        return animation
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion?(flag, anim)
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        preparing?(anim)
    }
}
