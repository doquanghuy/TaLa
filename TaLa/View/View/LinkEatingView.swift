//
//  EatingView.swift
//  TaLa
//
//  Created by huydoquang on 1/17/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class LinkEatingView: UIView {
    private let spaceBetweenTwoLinkViews: CGFloat = 20.0
    private let normalWidthSize: CGFloat = 5.0
    private let lastCardWidthSize: CGFloat = 10.0
    private let duration = 0.5
    private var viewModel: LinkEatingViewModel!
    private var direction: Direction!
    private var completion: ((String?, CGPoint) -> Void)?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    init(viewModel: LinkEatingViewModel, eatingView: UIView, ateView: UIView, containerView: UIView, completion: ((String?, CGPoint) -> Void)? = nil) {
        self.viewModel = viewModel
        self.completion = completion
        super.init(frame: self.frame(from: eatingView, with: ateView, and: containerView))
        self.setupFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupFromXib()
    }
    
    private func animation(frame: CGRect, duration: Double) {
        self.animationTransition(duration: duration / 2.0, frame: frame) {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.completion?(weakSelf.viewModel.content, weakSelf.center)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.animation(frame: self.frame, duration: self.duration)
    }
    
    private func animationTransition(duration: Double, frame: CGRect, reverse: Bool = false, completion: (() -> Void)? = nil) {
        switch self.direction {
        case .up:
            self.topConstraint.constant = reverse ? 0.0 : frame.height
            self.layoutIfNeeded()
            self.topConstraint.constant = reverse ? frame.height : 0.0
        case .down:
            self.bottomConstraint.constant = reverse ? 0.0 : frame.height
            self.layoutIfNeeded()
            self.bottomConstraint.constant = reverse ? frame.height : 0.0
        case .left:
            self.leadingConstraint.constant = reverse ? 0.0 : frame.width
            self.layoutIfNeeded()
            self.leadingConstraint.constant = reverse ? frame.width : 0.0
        default:
            self.trailingConstraint.constant = reverse ? 0.0 : frame.width
            self.layoutIfNeeded()
            self.trailingConstraint.constant = reverse ? frame.width : 0.0
        }
        
        self.backgroundView.backgroundColor = viewModel.color
        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            completion?()
        }
    }
    
    private func frame(from eatingView: UIView, with ateView: UIView, and containerView: UIView) -> CGRect {
        let eatingViewCenter = containerView.convert(eatingView.center, from: eatingView.superview)
        let ateViewCenter = containerView.convert(ateView.center, from: ateView.superview)

        let space = Math.distance(from: eatingViewCenter, to: ateViewCenter)
        self.direction = self.direction(from: eatingViewCenter, and: ateViewCenter)
        
        var size: CGSize!
        var origin: CGPoint!
        var margin: CGFloat!
        let widthSize = self.viewModel.eatType == .normal ? normalWidthSize : lastCardWidthSize
        
        switch viewModel.times {
        case 1:
            margin = 0.0
        case 2:
            margin = -(spaceBetweenTwoLinkViews + widthSize)
        default:
            margin = spaceBetweenTwoLinkViews + widthSize
        }
        
        switch direction {
        case .up:
            size = CGSize(width: widthSize, height: space)
            origin = CGPoint(x: ateViewCenter.x - widthSize / 2.0 + margin, y: ateViewCenter.y)
        case .down:
            size = CGSize(width: widthSize, height: space)
            origin = CGPoint(x: eatingViewCenter.x - widthSize / 2.0 + margin, y: eatingViewCenter.y)
        case .left:
            size = CGSize(width: space, height: widthSize)
            origin = CGPoint(x: ateViewCenter.x, y: ateViewCenter.y - widthSize / 2.0 + margin)
        default:
            size = CGSize(width: space, height: widthSize)
            origin = CGPoint(x: eatingViewCenter.x, y: eatingViewCenter.y - widthSize / 2.0 + margin)
        }
        
        return CGRect(origin: origin, size: size)
    }
    
    private func direction(from eatingViewCenter: CGPoint, and ateViewCenter: CGPoint) -> Direction! {
        if eatingViewCenter.x == ateViewCenter.x {
            return eatingViewCenter.y > ateViewCenter.y ? .up : .down
        } else if eatingViewCenter.y == ateViewCenter.y {
            return eatingViewCenter.x > ateViewCenter.x ? .left : .right
        }
        return nil
    }
    
    func reverseAnimation(completion: (() -> Void)? = nil) {
        self.animationTransition(duration: self.duration / 2.0, frame: self.frame, reverse: true, completion: completion)
    }
}
