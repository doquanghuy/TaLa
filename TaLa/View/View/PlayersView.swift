//
//  PlayersView.swift
//  TaLa
//
//  Created by huydoquang on 12/23/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

@objc protocol PlayersViewDelegate: class {
    func playerViewDidBeginChangePosition(playerView: UIImageView, bounderView: BounderView)
    func playerViewChangingPosition(playerView: UIImageView, bounderView: BounderView)
    func playerViewDidEndChangePosition(from fromPlayerView: UIImageView, to toPlayerView: UIImageView, from fromBounderView: BounderView, to toBounderView: BounderView)
    func playerViewDidTap(playerView: UIImageView, playerNumber: Int)
}

extension PlayersViewDelegate {
    func playerViewDidBeginChangePosition(playerView: UIImageView, bounderView: BounderView) {}
    func playerViewChangingPosition(playerView: UIImageView, bounderView: BounderView) {}
    func playerViewDidEndChangePosition(from fromPlayerView: UIImageView, to toPlayerView: UIImageView, from fromBounderView: BounderView, to toBounderView: BounderView) {}
    func playerViewDidTap(playerView: UIImageView, playerNumber: Int) {}
}

class PlayersView: UIView {
    @IBOutlet var bounders: [BounderView]!
    @IBOutlet var tapGestures: [UITapGestureRecognizer]!
    @IBOutlet var panGestures: [UIPanGestureRecognizer]!
    @IBOutlet weak var playerView1: UIImageView!
    @IBOutlet weak var playerView2: UIImageView!
    @IBOutlet weak var playerView3: UIImageView!
    @IBOutlet weak var playerView4: UIImageView!
    
    @IBOutlet weak var delegate: PlayersViewDelegate?
    private var firstLocation: CGPoint!
    private var newPlayerView: UIImageView!
    private var currentBounderViewTag: Int!
    private var bounderInsides = [BounderView]()
    private var viewModel: PlayersViewModelInterface = PlayersViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupFromXib()
        self.setupGestures(enableSwapPlayers: true, enableEditPlayerInfo: true)
        self.updateUIWithPlayers()
    }
    
    private func setupUI() {        
        [playerView1, playerView2, playerView3, playerView4]
            .forEach {
                $0?.makeViewCircle(maskToBound: true)
                $0?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        }
    }
    
    private func updateUIWithPlayers() {
        for i in 1...4 {
            if let player = self.viewModel.player(at: i), let imageName = player.image, let fullPath = TLFileManager.shared.fullImagePath(from: imageName) {
                [playerView1, playerView2, playerView3, playerView4][i - 1]?.image = UIImage(contentsOfFile: fullPath)
            }
        }
    }
    
    private func setupGestures(enableSwapPlayers: Bool, enableEditPlayerInfo: Bool) {
        tapGestures.forEach {$0.isEnabled = enableEditPlayerInfo}
        panGestures.forEach {$0.isEnabled = enableSwapPlayers}
    }
    
    private func disablePanGestures(exclude playerView: UIView) {
        [playerView1, playerView2, playerView3, playerView4]
            .filter {$0 != playerView}
            .flatMap {$0?.gestureRecognizers?.filter {$0 is UIPanGestureRecognizer}.first}
            .forEach {$0.isEnabled = false}
    }
    
    private func enablePanGestures() {
        [playerView1, playerView2, playerView3, playerView4]
            .flatMap {$0?.gestureRecognizers?.filter {$0 is UIPanGestureRecognizer}.first}
            .forEach {$0.isEnabled = true}
    }
    
    private func setupObserver(with playerView: UIView) {
        let checkViewPosition: CheckViewPosition = {[weak self] (bounderView, playerView, isInside) -> Void in
            guard let this = self, let bounderView = bounderView else { return }
            if !this.bounderInsides.contains(bounderView), isInside {
                this.bounderInsides.append(bounderView)
            } else if !isInside {
                this.bounderInsides = this.bounderInsides.filter {$0 != bounderView}
            }
            this.bounderInsides.last?.updateUI(isInside: true)
            this.bounderInsides.dropLast().forEach {$0.updateUI(isInside: false)}
            this.bounders.filter {!this.bounderInsides.contains($0)}.forEach {$0.updateUI(isInside: false)}
        }
        
        for bounderView in bounders where bounderView.tag != self.currentBounderViewTag {
            bounderView.setup(viewChangedPosition: checkViewPosition)
            bounderView.observerViewPosition(view: self.newPlayerView, isInside: false)
        }
    }
    
    private func playerView(from bounderView: BounderView) -> UIImageView? {
        guard bounderView.tag <= 4 else { return nil }
        return [playerView1, playerView2, playerView3, playerView4][bounderView.tag - 1]
    }
    
    private func playerView(from playerNumber: Int) -> UIImageView? {
        guard playerNumber <= 4 else { return nil }
        return [playerView1, playerView2, playerView3, playerView4][playerNumber - 1]
    }
    
    private func processWithBeganState(gesture: UIPanGestureRecognizer) {
        guard let playerView = gesture.view as? UIImageView, let bounderView = playerView.superview as? BounderView else { return }
        playerView.isHidden = true
        self.disablePanGestures(exclude: playerView)
        self.newPlayerView = playerView.temp(on: self)
        self.currentBounderViewTag = bounderView.tag
        self.setupObserver(with: self.newPlayerView)
        self.firstLocation = newPlayerView.center
        self.delegate?.playerViewDidBeginChangePosition(playerView: self.newPlayerView, bounderView: bounderView)
    }
    
    private func processWithChangedState(gesture: UIPanGestureRecognizer) {
        guard let playerView = gesture.view as? UIImageView, let bounderView = playerView.superview as? BounderView else { return }
        self.newPlayerView.center = gesture.location(in: self)
        self.delegate?.playerViewChangingPosition(playerView: self.newPlayerView, bounderView: bounderView)
    }
    
    private func processWithEndState(gesture: UIPanGestureRecognizer) {
        guard let playerView = gesture.view as? UIImageView, let bounderView = playerView.superview as? BounderView else { return }
        
        let reset = {[weak self] in
            guard let weakSelf = self else { return }
            playerView.center = bounderView.convert(weakSelf.newPlayerView.center, from: weakSelf.newPlayerView.superview)
            playerView.isHidden = false
            weakSelf.newPlayerView.isHidden = true
            weakSelf.newPlayerView.center = weakSelf.firstLocation
            weakSelf.newPlayerView.removeFromSuperview()
            weakSelf.newPlayerView = nil
            weakSelf.currentBounderViewTag = nil
            weakSelf.enablePanGestures()
        }
        
        if let insideTag = self.bounderInsides.last?.tag, let toPlayerView = self.playerView(from: insideTag), let toBounderView = self.viewWithTag(insideTag) as? BounderView {
            reset()
            let size = CGSize(width: 100.0, height: 100.0)
            let firstCenter = bounderView.convert(bounderView.center, from: bounderView.superview)
            let secondCenter = toBounderView.convert(toBounderView.center, from: toBounderView.superview)
            let firstOrigin = CGPoint(x: firstCenter.x - size.width / 2.0, y: firstCenter.y - size.height / 2.0)
            let secondOrigin = CGPoint(x: secondCenter.x - size.width / 2.0, y: secondCenter.y - size.height / 2.0)
            let firstFrame = CGRect(origin: firstOrigin, size: size)
            let secondFrame = CGRect(origin: secondOrigin, size: size)
            UIView.animationSwap(firstView: playerView, with: firstFrame, to: toPlayerView, with: secondFrame, sameParentView: self)
            self.delegate?.playerViewDidEndChangePosition(from: playerView, to: toPlayerView, from: bounderView, to: toBounderView)
        } else if let newFrame = self.newPlayerView.superview?.convert(playerView.frame, from: playerView.superview){
            self.newPlayerView.animationToMatch(newFrame: newFrame, updateNewFrameWhenCancel: true) {
                reset()
            }
        }
    }
    
    func updateUI(image: UIImage?, name: String?, playerNumber: Int) {
        self.playerView(from: playerNumber)?.image = image
    }
    
    @IBAction func processPanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.processWithBeganState(gesture: sender)
            break
        case .changed:
            self.processWithChangedState(gesture: sender)
            break
        case .cancelled, .ended, .failed:
            self.processWithEndState(gesture: sender)
            break
        default:
            break
        }
    }
    
    @IBAction func fillPlayerInfo(_ sender: UITapGestureRecognizer) {
        guard let playerView = sender.view as? UIImageView else { return }
        self.delegate?.playerViewDidTap(playerView: playerView, playerNumber: playerView.superview?.tag ?? 0)
    }
}
