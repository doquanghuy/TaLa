//
//  BounderViewModel.swift
//  TaLa
//
//  Created by huydoquang on 12/22/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

protocol BounderViewModelInterface {
    weak var view: UIView! { get set }
    var isInside: Dynamic<(UIView?, Bool)> { get }
    func observerViewPosition(view: UIView, isInside: Bool)
}

class BounderViewModel: NSObject, BounderViewModelInterface {
    private var observer: NSKeyValueObservation?
    var isInside: Dynamic<(UIView?, Bool)> = Dynamic((nil, false))
    weak var view: UIView!
    
    func observerViewPosition(view: UIView, isInside: Bool) {
        self.isInside.value = (view, isInside)
        self.observer = view.observe(\UIView.center, options: .new) {[weak self] (observedView, center) in
            guard let this = self else { return }
            let frame = this.view.convert(observedView.frame, from: observedView.superview)
            this.isInside.value = (observedView, this.checkViewFrameIsInside(frame: frame))
        }
    }

    private func checkViewFrameIsInside(frame: CGRect) -> Bool {
        let topPoint = CGPoint(x: frame.minX + frame.width / 2, y: frame.minY)
        let bottomPoint = CGPoint(x: frame.minX + frame.width / 2, y: frame.maxY)
        let leftPoint = CGPoint(x: frame.minX, y: frame.midY)
        let rightPoint = CGPoint(x: frame.maxX, y: frame.midY)
        
        return ![topPoint, leftPoint, bottomPoint, rightPoint].filter {self.view.bounds.contains($0)}.isEmpty
    }
    
    deinit {
        self.observer?.invalidate()
    }
}
