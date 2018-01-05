//
//  BounderView.swift
//  TaLa
//
//  Created by huydoquang on 12/22/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

typealias CheckViewPosition = ((BounderView?, UIView?, Bool) -> Void)

protocol BounderViewInterface {
    var viewChangedPostion: CheckViewPosition? { get }
    func observerViewPosition(view: UIView, isInside: Bool)
    func setup(viewChangedPosition: CheckViewPosition?)
    func updateUI(isInside: Bool)
}

class BounderView: UIView, BounderViewInterface {
    var viewModel: BounderViewModelInterface?
    var viewChangedPostion: CheckViewPosition?
    var isInside = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewModel = BounderViewModel()
        self.setupObserver()
    }
    
    private func setupObserver() {
        self.viewModel?.isInside.bind {[weak self] (view, isInside) in
            self?.viewChangedPostion?(self, view, isInside)
        }
    }
    
    func updateUI(isInside: Bool) {
        guard self.isInside != isInside else { return }
        self.isInside = isInside
        self.layer.borderColor = isInside ? UIColor.lightBlue?.cgColor : UIColor.darkGray.cgColor
        self.layer.borderWidth = isInside ? 7.0 : 0.5
    }
    
    func setup(viewChangedPosition: CheckViewPosition?) {
        self.viewModel?.view = self
        self.viewChangedPostion = viewChangedPosition
    }
    
    func observerViewPosition(view: UIView, isInside: Bool) {
        viewModel?.observerViewPosition(view: view, isInside: isInside)
    }
}
