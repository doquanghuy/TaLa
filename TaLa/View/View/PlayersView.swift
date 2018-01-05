//
//  PlayersView.swift
//  TaLa
//
//  Created by huydoquang on 12/23/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

protocol PlayersViewDelegate: class {
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

class PlayerViewOwner: NSObject {
    @IBOutlet var playersView: PlayersView!
}

class PlayersView: UIView {
    @IBOutlet var bounders: [BounderView]!
    @IBOutlet var tapGestures: [UITapGestureRecognizer]!
    @IBOutlet var panGestures: [UIPanGestureRecognizer]!
    @IBOutlet weak var playerView1: UIImageView!
    @IBOutlet weak var playerView2: UIImageView!
    @IBOutlet weak var playerView3: UIImageView!
    @IBOutlet weak var playerView4: UIImageView!
    
    private weak var delegate: PlayersViewDelegate?
    private var firstLocation: CGPoint!
    private var newPlayerView: UIImageView!
    private var currentBounderViewTag: Int!
    private var bounderInsides = [BounderView]()
    private var viewModel: PlayersViewModelInterface = PlayersViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
        
    static func addView(to view: UIView, with frame: CGRect, delegate: PlayersViewDelegate, enableEditPlayerInfo: Bool = true, enableSwapPlayers: Bool = true, completion: (() -> Void)? = nil) -> PlayersView {
        let owner = PlayerViewOwner()
        Bundle.main.loadNibNamed(String(describing: self), owner: owner, options: nil)
        owner.playersView.delegate = delegate
        owner.playersView.frame = frame
        owner.playersView.setupGestures(enableSwapPlayers: enableSwapPlayers, enableEditPlayerInfo: enableEditPlayerInfo)
        view.addSubview(owner.playersView)
        owner.playersView.updateUIWithPlayers()
        owner.playersView.transform = CGAffineTransform.identity.scaledBy(x: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 0.25, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            owner.playersView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }) { (finished) in
            owner.playersView.transform = CGAffineTransform.identity
            completion?()
        }
        return owner.playersView
    }
    
    private func setupUI() {
        self.bounders.forEach { (bounderView) in
            bounderView.layer.borderColor = UIColor.darkGray.cgColor
            bounderView.layer.borderWidth = 0.5
            bounderView.layer.cornerRadius = 5.0
        }
    }
    
    private func updateUIWithPlayers() {
        for i in 1...4 {
            let player = self.viewModel.player(at: i)
            [playerView1, playerView2, playerView3, playerView4][i - 1]?.image = UIImage(contentsOfFile: player?.image ?? "")
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
        let newFrame = CGRect(origin: .zero, size: playerView.frame.size)
        self.disablePanGestures(exclude: playerView)
        self.newPlayerView = UIImageView(frame: newFrame)
        self.newPlayerView.center = self.convert(playerView.center, from: playerView.superview)
        self.newPlayerView.image = playerView.image
        self.newPlayerView.backgroundColor = playerView.backgroundColor
        self.currentBounderViewTag = bounderView.tag
        self.setupObserver(with: self.newPlayerView)
        self.addSubview(self.newPlayerView)
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
        if let insideTag = self.bounderInsides.last?.tag, let toPlayerView = self.playerView(from: insideTag), let toBounderView = self.viewWithTag(insideTag) as? BounderView {
            let center = bounderView.convert(self.newPlayerView.center, from: self.newPlayerView.superview)
            playerView.center = center
            self.delegate?.playerViewDidEndChangePosition(from: playerView, to: toPlayerView, from: bounderView, to: toBounderView)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.newPlayerView.center = self.firstLocation
        }) { (finished) in
            playerView.isHidden = false
            self.newPlayerView.removeFromSuperview()
            self.newPlayerView = nil
            self.currentBounderViewTag = nil
            self.enablePanGestures()
        }
    }
    
    func updateUI(image: UIImage?, name: String?, playerNumber: Int) {
        self.playerView(from: playerNumber)?.image = image
    }
    
    func swapPlayerViewLocation(from fromPlayerView: UIImageView, to toPlayerView: UIImageView, from fromBounderView: BounderView, to toBounderView: BounderView) {
        let toImage = toPlayerView.image
        let fromImage = fromPlayerView.image
        
        fromPlayerView.isHidden = true
        let newFrame = CGRect(origin: .zero, size: fromPlayerView.frame.size)
        let newFromPlayerView = UIImageView(frame: newFrame)
        newFromPlayerView.backgroundColor = fromPlayerView.backgroundColor
        newFromPlayerView.image = fromImage
        newFromPlayerView.center = self.convert(fromPlayerView.center, from: fromPlayerView.superview)
        fromPlayerView.center = fromBounderView.convert(fromBounderView.center, from: fromBounderView.superview)
        self.addSubview(newFromPlayerView)
        
        toPlayerView.isHidden = true
        let newToPlayerView = UIImageView(frame: CGRect(origin: .zero, size: toPlayerView.frame.size))
        newToPlayerView.image = toPlayerView.image
        newToPlayerView.backgroundColor = toPlayerView.backgroundColor
        newToPlayerView.center = self.convert(toPlayerView.center, from: toPlayerView.superview)
        self.addSubview(newToPlayerView)
        
        UIView.animate(withDuration: 0.25, animations: {
            newFromPlayerView.center = self.convert(toPlayerView.center, from: toPlayerView.superview)
            newToPlayerView.center = self.convert(fromBounderView.center, from: fromBounderView.superview)
        }) { (finished) in
            toPlayerView.image = fromImage
            toPlayerView.isHidden = false
            newFromPlayerView.removeFromSuperview()
            
            fromPlayerView.image = toImage
            fromPlayerView.isHidden = false
            newToPlayerView.removeFromSuperview()
        }
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
