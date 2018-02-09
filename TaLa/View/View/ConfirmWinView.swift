//
//  ConfirmWinView.swift
//  TaLa
//
//  Created by huydoquang on 1/20/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol ConfirmWinViewDelegate: class {
    func processWhenResultIsWinLost(confirmView: ConfirmWinView, winViewTag: Int, lostViewTag: Int, isCirle: Bool, ateThreeCards: Bool)
}

class ConfirmWinView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var winImgView: UIImageView!
    @IBOutlet weak var lostImgView: UIImageView!
    @IBOutlet weak var winCircleButton: UIButton!
    @IBOutlet weak var winAllButton: UIButton!
    private var sourceWinViewTag: Int!
    private var sourceLostViewTag: Int!
    private var ateThreeCards: Bool!
    
    weak var delegate: ConfirmWinViewDelegate?
    
    init(frame: CGRect, sourceWinViewTag: Int, sourceLostViewTag: Int, ateThreeCards: Bool) {
        self.sourceWinViewTag = sourceWinViewTag
        self.sourceLostViewTag = sourceLostViewTag
        self.ateThreeCards = ateThreeCards
        super.init(frame: frame)
        self.setupFromXib()
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupFromXib()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layoutIfNeeded()
    }
    
    private func setupUI() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.winCircleButton.layer.cornerRadius = 5.0
        self.winAllButton.layer.cornerRadius = 5.0
        self.winCircleButton.layer.masksToBounds = true
        self.winAllButton.layer.masksToBounds = true
        self.winAllButton.setTitle(Constants.String.winAll, for: .normal)
        self.winCircleButton.setTitle(Constants.String.winCircle, for: .normal)
    }
    
    func animation(sourceWinView: UIView, sourceLostView: UIView) {
        sourceWinView.animationToMatch(with: self.winImgView, updateNewFrameWhenCancel: true)
        sourceLostView.animationToMatch(with: self.lostImgView, updateNewFrameWhenCancel: true)
    }

    @IBAction func clickWinCircleButton(_ sender: Any) {
        self.delegate?.processWhenResultIsWinLost(confirmView: self, winViewTag: self.sourceWinViewTag, lostViewTag: self.sourceLostViewTag, isCirle: true, ateThreeCards: self.ateThreeCards)
    }
    
    @IBAction func clickWinAllButton(_ sender: Any) {
        self.delegate?.processWhenResultIsWinLost(confirmView: self, winViewTag: self.sourceWinViewTag, lostViewTag: self.sourceLostViewTag, isCirle: false, ateThreeCards: self.ateThreeCards)
    }
}
