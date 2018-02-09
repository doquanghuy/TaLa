//
//  Ext+UIView.swift
//  TaLa
//
//  Created by huydoquang on 12/23/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

extension UIView {
    var subViewsRecursive: [UIView] {
        var results = [UIView]()
        for subView in subviews {
            results.append(subView)
            results.append(contentsOf: subView.subViewsRecursive)
        }
        return results
    }
    
    var isCircle: Bool {
        return self.layer.cornerRadius == self.bounds.width / 2.0
    }
    
    static func setTintColor(tintColor: UIColor) {
        self.appearance().tintColor = tintColor
    }
    
    func makeViewCircle(maskToBound: Bool = false) {
        guard !self.isCircle else {return}
        self.layer.cornerRadius = self.frame.width / 2.0
        self.layer.masksToBounds = maskToBound
    }
    
    func deactiveConstraints() {
        self.constraints.forEach {$0.isActive = false}
    }
    
    func setupFromXib(viewName: String? = nil) {
        guard let view = Bundle.main.loadNibNamed(viewName ?? String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView  else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
        
    func translateAndRotate(sender: CustomSwipeGestureRecognizer, containerView: UIView, completion: ((CGPoint) -> Void)? = nil) {
        let angel = sender.angel * Double.pi / 180.0
        let startPoint = containerView.convert(sender.endLocation, from: self)
        let velocity = sender.velocity
        let destination = Math.destinationPoint(angel: angel, and: startPoint, on: containerView) ?? .zero
        self.translateAndRotate(from: startPoint, to: destination, velocity: velocity, on: containerView) {[weak self] (destination) in
            completion?(destination)
        }
    }
    
    func translateAndRotate(from startPoint: CGPoint, to destination: CGPoint, velocity: Double, on containerView: UIView, completion: ((CGPoint) -> Void)? = nil) {
        let distance = Math.distance(from: startPoint, to: destination)
        let duration = Double(distance) / velocity
        
        let transX = destination.x - startPoint.x
        let transY = destination.y - startPoint.y
        let translation = CustomCABasicAnimation.animation(keyPath: "transform.translation")
        translation.fromValue = CGPoint.zero
        translation.toValue = CGPoint(x: transX, y: transY)
        
        let rotation = CustomCABasicAnimation.animation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = Double.pi * 2 * 0.25 / duration
        
        let group = CustomCAAnimationGroup.animation() {[weak self] (finished, anim) in
            guard let weakSelf = self else {return}
            weakSelf.frame.origin = weakSelf.superview!.convert(destination, from: containerView)
            weakSelf.layer.removeAllAnimations()
            completion?(destination)
        }
        group.animations = [translation, rotation]
        group.duration = duration
        group.fillMode = kCAFillModeBoth
        group.isRemovedOnCompletion = false
        self.layer.add(group, forKey: "translateAndRotateEndless")
    }
    
    func animationToMatch(duration: Double = 1.0, with desView: UIView, updateNewFrameWhenCancel: Bool = false, completion: (() -> Void)? = nil) {
        guard let superView = self.superview else { return }
        let newFrame = superView.convert(desView.frame, from: desView.superview)
        self.animationToMatch(duration: duration, newFrame: newFrame, updateNewFrameWhenCancel: updateNewFrameWhenCancel, completion: completion)
    }
    
    func animationToMatch(duration: Double = 0.25, newFrame: CGRect, updateNewFrameWhenCancel: Bool = false, completion: (() -> Void)? = nil) {
        self.layer.removeAnimation(forKey: "translationAndScale")
        let desCenter = CGPoint(x: newFrame.midX, y: newFrame.midY)
        let transX = desCenter.x - self.frame.width / 2.0 - self.frame.origin.x
        let transY = desCenter.y - self.frame.height / 2.0 - self.frame.origin.y
        let scaleX = newFrame.width / self.frame.size.width
        
        let translation = CustomCABasicAnimation.animation(keyPath: "transform.translation")
        translation.fromValue = NSValue(cgPoint: .zero)
        
        let scale = CustomCABasicAnimation.animation(keyPath: "transform.scale")
        scale.fromValue = NSNumber(value: 1.0)
        
        let transformTranslation = CATransform3DTranslate(self.layer.transform, transX, transY, 1.0)
        self.layer.transform = CATransform3DScale(transformTranslation, scaleX, scaleX, 1.0)
        
        let group = CustomCAAnimationGroup.animation {[weak self](finished, anim) in
            guard let weakSelf = self, (finished || updateNewFrameWhenCancel) else {
                completion?()
                return
            }
            weakSelf.layer.transform = CATransform3DIdentity
            weakSelf.frame = newFrame
            weakSelf.layer.cornerRadius = newFrame.width / 2.0
            completion?()
        }
        group.duration = duration
        group.animations = [translation, scale]
        self.layer.add(group, forKey: "translationAndScale")
    }
    
    static func animationSwap(firstView: UIImageView, with firstFrame: CGRect, to secondView: UIImageView, with secondFrame: CGRect, sameParentView: UIView, completion: (() -> Void)? = nil) {
        firstView.isHidden = true
        secondView.isHidden = true
        
        let fakeFirstView = firstView.temp(on: sameParentView)
        let fakeSecondView = secondView.temp(on: sameParentView)
        
        firstView.frame = firstFrame
        secondView.frame = secondFrame

        let secondFrameByFakeFirstView = sameParentView.convert(secondFrame, from: secondView.superview)
        let firstFrameByFakeSecondView = sameParentView.convert(firstFrame, from: firstView.superview)
        
        let group = DispatchGroup()
        
        group.enter()
        fakeFirstView.animationToMatch(newFrame: secondFrameByFakeFirstView, updateNewFrameWhenCancel: true) {
            firstView.isHidden = false
            firstView.getInfo(from: fakeSecondView)
            group.leave()
        }
        
        group.enter()
        fakeSecondView.animationToMatch(newFrame: firstFrameByFakeSecondView, updateNewFrameWhenCancel: true) {
            secondView.isHidden = false
            secondView.getInfo(from: fakeFirstView)
            group.leave()
        }
        group.notify(queue: .main) {
            fakeFirstView.removeFromSuperview()
            fakeSecondView.removeFromSuperview()
            completion?()
        }
    }
        
    func disable() {
        self.isUserInteractionEnabled = false
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
    }
    
    func disappear(duration: Double = 0.25, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }) { (finished) in
            completion?()
        }
    }
    
    func appear(duration: Double = 0.25, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }) { (finished) in
            completion?()
        }
    }
    
    func roundedCorners(top: Bool, cornerRadius: CGFloat){
        let corners: UIRectCorner = (top ? [.topLeft, .topRight] : [.bottomRight, .bottomLeft])
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
}
