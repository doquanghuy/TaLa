//
//  RoundOrderView.swift
//  TaLa
//
//  Created by huydoquang on 1/7/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol RoundOrderViewDatasource: class {
    func roundLevelViewModel(at tag: Int) -> RoundLevelViewModel
}

protocol RoundOrderViewDelegate: class {
    func willDisplayLevelView(orderView: RoundOrderView, with levelView: RoundLevelView, at tag: Int, total: Int)
    func didDisplayLevelView(orderView: RoundOrderView, with levelView: RoundLevelView, at tag: Int, total: Int)
    func didEndReload(orderView: RoundOrderView)
}

extension RoundOrderViewDelegate {
    func willDisplayLevelView(orderView: RoundOrderView, with levelView: RoundLevelView, at tag: Int, total: Int) {}
    func didDisplayLevelView(orderView: RoundOrderView, with levelView: RoundLevelView, at tag: Int, total: Int) {}
    func didEndReload(orderView: RoundOrderView) {}
}

class RoundOrderView: UIView {
    private let multiplierHeight: CGFloat = 1.1
    weak var delegate: RoundOrderViewDelegate?
    weak var datasource: RoundOrderViewDatasource?
    private var viewModel: RoundOrderViewModelInterface = RoundOrderViewModel()
    
    func reloadData(resultType: Result) {
        var originX: CGFloat = 20.0
        var levelViews = [RoundLevelView]()
        for index in 0..<self.numberLevelView(resultType: resultType) {
            let size = self.sizeOfLevelView(resultType: resultType, at: index + 1)
            let origin = CGPoint(x: originX, y: self.frame.height - size.height + 5.0)
            let frame = CGRect(origin: origin, size: size)
            originX += size.width + 20.0
            let levelView = RoundLevelView(frame: frame)
            levelViews.append(levelView)
            self.addSubview(levelView)
        }

        self.setTagForLevelView(result: resultType, and: levelViews)
        self.layoutIfNeeded()
        
        for levelView in self.subviews.flatMap({$0 as? RoundLevelView}) {
            let viewModel = self.viewModel.roundLevelViewModel(at: levelView.tag, result: resultType)
            self.delegate?.willDisplayLevelView(orderView: self, with: levelView, at: levelView.tag, total: levelViews.count)
            levelView.setup(with: viewModel)
            self.delegate?.didDisplayLevelView(orderView: self, with: levelView, at: levelView.tag, total: levelViews.count)
        }
        self.delegate?.didEndReload(orderView: self)
    }
    
    func undo() {
        self.subviews.forEach {$0.removeFromSuperview()}
    }
    
    fileprivate func numberLevelView(resultType: Result) -> Int {
        switch resultType {
        case .normal, .winAll:
            return 4
        default:
            return 2
        }
    }
    
    fileprivate func sizeOfLevelView(resultType: Result, at tag: Int) -> CGSize {
        switch resultType {
        case .normal(let numberNotEat):
            return sizeOfNormalResult(at: tag, numberNotEat: numberNotEat)
        case .winAll:
            return sizeOfWinResult(at: tag)
        default:
            return sizeOfWinLost(at: tag)
        }
    }
    
    fileprivate func sizeOfNormalResult(at tag: Int, numberNotEat: Int) -> CGSize {
        let width = (self.bounds.width - CGFloat(20.0) * CGFloat(self.numberLevelView(resultType: .normal(numberNotEat: numberNotEat)) + 1)) / CGFloat(self.numberLevelView(resultType: .normal(numberNotEat: numberNotEat)))
        let height = self.bounds.height
        let orderTags = [2, 1, 3, 4][0..<(4 - numberNotEat)]
        
        if orderTags.contains(tag) {
            let index = orderTags.index(of: tag)!
            return CGSize.init(width: width, height: height / pow(multiplierHeight, CGFloat(index - 1)))
        } else {
            return CGSize.init(width: width, height: height / pow(multiplierHeight, 4))
        }
    }
    
    fileprivate func sizeOfWinResult(at tag: Int) -> CGSize {
        let width = (self.bounds.width - CGFloat(20.0) * CGFloat(self.numberLevelView(resultType: .winAll) + 1)) / CGFloat(self.numberLevelView(resultType: .normal(numberNotEat: 0)))
        var height = self.bounds.height
        switch tag {
        case 1, 3, 4:
            height = height / pow(multiplierHeight, 2)
        default:
            break
        }
        return CGSize(width: width, height: height)
    }
    
    fileprivate func sizeOfWinLost(at tag: Int) -> CGSize {
        let width = (self.bounds.width - CGFloat(20.0) * CGFloat(self.numberLevelView(resultType: .winLost) + 1)) / CGFloat(self.numberLevelView(resultType: .winLost))
        var height = self.bounds.height
        switch tag {
        case 2:
            height = height / pow(multiplierHeight, 2)
        default:
            break
        }
        return CGSize(width: width, height: height)
    }
    
    fileprivate func setTagForLevelView(result: Result, and levelViews: [RoundLevelView]) {
        switch result {
        case .normal, .winAll:
            for (index, value) in [2, 1, 3, 4].enumerated() {
                levelViews[index].tag = value
            }
        case .winLost:
            for (index, levelView) in levelViews.enumerated() {
                levelView.tag = index + 1
            }
        }
    }
}
