//
//  RoundPlayerView.swift
//  TaLa
//
//  Created by huydoquang on 1/5/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol RoundPlayerViewDelegate: class {
    func playerDidEat(eatingPlayerIndex: Int, eatingPlayerView: UIView, atePlayerIndex: Int, atePlayerView: UIView)
    func playerDidEatLastCard(eatingPlayerIndex: Int, eatingPlayerView: UIView, atePlayerIndex: Int, atePlayerView: UIView)
    func didEndRoundNormalResult(orderViews: [UIView], orderIndexs: [Int], notEatViews: [UIView], notEatIndexs: [Int])
    func didEndRoundWinAll(winPlayerIndex: Int, winPlayerView: UIView, lostPlayerIndexs: [Int], lostPlayerViews: [UIView], isCircle: Bool, isDry: Bool)
    func didEndRoundWinLost(winPlayerIndex: Int, winPlayerView: UIView, lostPlayerIndex: Int, lostPlayerView: UIView, ateThreeCards: Bool)
}

class RoundPlayerView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var imgViews: [UIImageView]!
    @IBOutlet weak var directionImageView: UIImageView!
    
    private var viewModel: RoundPlayerViewModelInterface = RoundPlayerViewModel()
    private var viewPassed = [UIView]()
    private var linkViews = [LinkEatingView]()
    private var isUsingLongPress = false
    
    weak var delegate: RoundPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGesture()
        self.setupUI()
    }
    
    private func setupUI() {
        self.layoutIfNeeded()
        self.imgViews.forEach {
            $0.makeViewCircle(maskToBound: true)
            $0.superview?.makeViewCircle()
        }
        self.viewModel.imagePaths.bind { (imgPaths) in
            self.imgViews.forEach {$0.image = UIImage(contentsOfFile: imgPaths[$0.tag - 1] ?? "")}
        }
        self.viewModel.directionImageName.bind { (imgName) in
            let newImage = UIImage(named: imgName)
            self.directionImageView.changeImage(to: newImage)
        }
        self.viewModel.didLoad()
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.processPanGesture(sender:)))
        self.addGestureRecognizer(panGesture)
        
        self.imgViews.forEach { (imgView) in
            imgView.isUserInteractionEnabled = true
            imgView.superview?.layer.cornerRadius = 5.0
            
            let customSwipe = CustomSwipeGestureRecognizer(target: self, action: #selector(self.processSwipeGesture(sender:)))
            panGesture.require(toFail: customSwipe)
            imgView.addGestureRecognizer(customSwipe)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.processDoubleTapGesture(sender:)))
            doubleTap.numberOfTapsRequired = 2
            imgView.addGestureRecognizer(doubleTap)
            
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.processSingleTapGesture(sender:)))
            singleTap.require(toFail: doubleTap)
            imgView.addGestureRecognizer(singleTap)
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.processLongPressGesture(sender:)))
            longPress.allowableMovement = CGFloat.infinity
            imgView.addGestureRecognizer(longPress)
        }
    }
    
    private func disappearSubViewsWhenEndRound(subViews: [UIView] = []) {
        self.disable()
        self.subViewsRecursive
            .filter {$0 is LinkEatingView }
            .forEach {$0.disappear(duration: 0.0)}
        subViews.forEach {$0.disappear()}
    }
    
    @objc func processLongPressGesture(sender: UILongPressGestureRecognizer) {
        guard let startView = sender.view as? UIImageView, let superView = startView.superview as? SpotlightView else { return }
        let desView = self.imgViews.filter {$0.bounds.contains(sender.location(in: $0)) && $0 != startView}.first
        let desSuperView = desView?.superview as? SpotlightView
        switch sender.state {
        case .began:
            superView.makeSpotlight(holdWhenComplete: true)
        case .changed:
            self.imgViews
                .filter {$0 != startView && $0 != desView}
                .flatMap {$0.superview as? SpotlightView}
                .forEach {$0.unMakeSpotlight(holdWhenComplete: true)}
            desSuperView?.makeSpotlight(holdWhenComplete: true)
        case .ended:
            guard desView != nil && desSuperView != nil else {
                self.imgViews
                    .flatMap {$0.superview as? SpotlightView}
                    .forEach {$0.unMakeSpotlight(holdWhenComplete: true)}
                return
            }
            self.isUsingLongPress = true
            self.imgViews
                .flatMap {$0.superview as? SpotlightView}
                .forEach {$0.unMakeSpotlight(holdWhenComplete: true)}
            self.viewPassed.append(contentsOf: [startView, desView!])
            self.delegate?.didEndRoundWinLost(winPlayerIndex: startView.tag, winPlayerView: startView, lostPlayerIndex: desView!.tag, lostPlayerView: desView!, ateThreeCards: false)
            self.disappearSubViewsWhenEndRound(subViews: self.imgViews.filter {![startView, desView!].contains($0)})
        default:
            self.imgViews
                .flatMap {$0.superview as? SpotlightView}
                .forEach {$0.unMakeSpotlight(holdWhenComplete: true)}
            break
        }
    }
    
    @objc func processSwipeGesture(sender: CustomSwipeGestureRecognizer) {
        guard let view = sender.view as? UIImageView else { return }
        view.translateAndRotate(sender: sender, containerView: self.superview!) {[weak self] (destination) in
            guard let weakSelf = self else { return }
            let lostPlayerIndexs = weakSelf.imgViews.flatMap {$0.tag}.filter {$0 != view.tag}
            let lostPlayerViews = weakSelf.imgViews.filter {$0 != view}
            weakSelf.viewPassed.append(view)
            switch sender.direction {
            case .up:
                weakSelf.delegate?.didEndRoundWinAll(winPlayerIndex: view.tag, winPlayerView: view, lostPlayerIndexs: lostPlayerIndexs, lostPlayerViews: lostPlayerViews, isCircle: true, isDry: false)
            case .down:
                weakSelf.delegate?.didEndRoundWinAll(winPlayerIndex: view.tag, winPlayerView: view, lostPlayerIndexs: lostPlayerIndexs, lostPlayerViews: lostPlayerViews, isCircle: false, isDry: true)
            default:
                weakSelf.delegate?.didEndRoundWinAll(winPlayerIndex: view.tag, winPlayerView: view, lostPlayerIndexs: lostPlayerIndexs, lostPlayerViews: lostPlayerViews, isCircle: false, isDry: false)
            }
        }
        self.disappearSubViewsWhenEndRound()
    }
    
    @objc func processDoubleTapGesture(sender: UITapGestureRecognizer) {
        let eatingPlayerView = sender.view!
        let atePlayerView = self.imgViews.filter {$0.tag == Player.nextPlayerIndex(currentId: eatingPlayerView.tag)}.first!
        self.delegate?.playerDidEatLastCard(eatingPlayerIndex: eatingPlayerView.tag, eatingPlayerView: eatingPlayerView, atePlayerIndex: atePlayerView.tag, atePlayerView: atePlayerView)
    }
    
    @objc func processSingleTapGesture(sender: UITapGestureRecognizer) {
        if self.isUserInteractionEnabled {
            let eatingPlayerView = sender.view!
            let atePlayerView = self.imgViews.filter {$0.tag ==  Player.nextPlayerIndex(currentId: eatingPlayerView.tag)}.first!
            self.delegate?.playerDidEat(eatingPlayerIndex: eatingPlayerView.tag, eatingPlayerView: eatingPlayerView, atePlayerIndex: atePlayerView.tag, atePlayerView: atePlayerView)
        }
    }
    
    @objc func processPanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let viewTouching = self.imgViews.filter {$0.bounds.contains(sender.location(in: $0))}.first
            guard viewTouching != nil && !self.viewPassed.contains(viewTouching!) else {return}
            self.viewPassed.append(viewTouching!)
            (viewTouching?.superview as? SpotlightView)?.makeSpotlight()
        case .ended:
            guard !self.viewPassed.isEmpty else {return}
            let notEatViews = self.imgViews.filter {!self.viewPassed.contains($0)}
            let notEatIndexs = notEatViews.flatMap {$0.tag}
            self.delegate?.didEndRoundNormalResult(orderViews: self.viewPassed, orderIndexs: self.viewPassed.flatMap {$0.tag}, notEatViews: notEatViews, notEatIndexs: notEatIndexs)
            self.disappearSubViewsWhenEndRound()
        default:
            break
        }
    }
    
    func setupLinkEatingView(from eatType: EatTypes, times: Int, eatingPlayerView: UIView, atePlayerView: UIView) {
        let linkEatingViewModel = LinkEatingViewModel(eatType: eatType, times: times)
        let linkEatingView = LinkEatingView(viewModel: linkEatingViewModel, eatingView: eatingPlayerView, ateView: atePlayerView, containerView: self, completion: {[weak self] (content, center) in
            guard let weakSelf = self else { return }
            FlyCaptionView.add(on: weakSelf, duration: 2.5, content: linkEatingViewModel.content, center: center)
        })
        self.linkViews.append(linkEatingView)
        self.insertSubview(linkEatingView, at: 0)
    }
    
    func undoSetupLinkEatingView(from eatType: EatTypes, times: Int, eatingPlayerView: UIView, atePlayerView: UIView) {
        let linkView = self.linkViews.removeLast()
        linkView.reverseAnimation {
            linkView.removeFromSuperview()
        }
    }
    
    func undoResult(completion: (() -> Void)? = nil) {
        self.isUsingLongPress = false
        self.viewPassed.removeAll()
        self.enable()
        
        let margin: CGFloat = 20.0
        let group = DispatchGroup()
        
        self.imgViews.forEach { (imgView) in
            guard let superView = imgView.superview else { return }
            group.enter()
            let tempView = UIView(frame: CGRect(x: margin, y: margin, width: superView.bounds.width - margin * 2.0, height: superView.bounds.height - margin * 2.0))
            superView.addSubview(tempView)
            imgView.animationToMatch(with: tempView, updateNewFrameWhenCancel: true, completion: {
                tempView.removeFromSuperview()
                group.leave()
            })
        }
        
        self.imgViews.forEach { (imgView) in
            group.enter()
            imgView.appear() {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {[weak self] in
            self?.subViewsRecursive
                .filter {$0 is LinkEatingView }
                .forEach {$0.appear()}
            completion?()
        }
    }
    
    func view(at tag: Int) -> UIView? {
        var fullViewPassed = viewPassed
        let notEatResult = {[unowned self] (tag: Int, numberViews: Int) -> UIView in
            let remainViews = self.imgViews.filter {!self.viewPassed.contains($0)} as [UIView]
            fullViewPassed.append(contentsOf: remainViews)
            return fullViewPassed[tag - 1]
        }
        switch viewPassed.count {
        case 2:
            if !self.isUsingLongPress {
               return notEatResult(tag, viewPassed.count)
            } else {
                return fullViewPassed[tag - 1]
            }
        case 1, 3, 4:
            return notEatResult(tag, viewPassed.count)
        default:
            break
        }
        return fullViewPassed[tag - 1]
    }
    
    func processWhenResultIsWinLostByAteThreeCards(winView: UIView, lostView: UIView) {
        self.viewPassed.append(contentsOf: [winView, lostView])
        self.delegate?.didEndRoundWinLost(winPlayerIndex: winView.tag, winPlayerView: winView, lostPlayerIndex: lostView.tag, lostPlayerView: lostView, ateThreeCards: true)
        self.disappearSubViewsWhenEndRound(subViews: self.imgViews.filter {![lostView, winView].contains($0)})
    }
    
    func reload() {
        self.viewModel.didLoad()
    }
    
    func reverse() {
        self.viewModel.didLoad()
    }
    
    func setDirectionImgView(isHidden: Bool) {
        self.directionImageView.isHidden = isHidden
    }
}
