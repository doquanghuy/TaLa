//
//  RoundOrderViewModel.swift
//  TaLa
//
//  Created by huydoquang on 2/1/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol RoundOrderViewModelInterface {
    func roundLevelViewModel(at tag: Int, result: Result) -> RoundLevelViewModel
}

class RoundOrderViewModel: RoundOrderViewModelInterface {
    func roundLevelViewModel(at tag: Int, result: Result) -> RoundLevelViewModel {
        switch result {
        case .normal(let numberNotEat):
            return roundLevelViewModelNormal(at: tag, numberNotEat: numberNotEat)
        case .winAll:
            return roundLevelViewModelWinAll(at: tag)
        case .winLost:
            return roundLevelViewModelWinLost(at: tag)
        }
    }
    
    private func roundLevelViewModelNormal(at tag: Int, numberNotEat: Int) -> RoundLevelViewModel {
        if tag <= 4 - numberNotEat {
            return RoundLevelViewModel(title: "\(tag)", image: nil, sourceImgView: nil)
        } else {
            return RoundLevelViewModel(title: "Móm", image: nil, sourceImgView: nil)
        }
    }
    
    private func roundLevelViewModelWinAll(at tag: Int) -> RoundLevelViewModel {
        if tag == 1 {
            return RoundLevelViewModel(title: "Ù", image: nil, sourceImgView: nil)
        } else {
            return RoundLevelViewModel(title: "Thua", image: nil, sourceImgView: nil)
        }
    }

    private func roundLevelViewModelWinLost(at tag: Int) -> RoundLevelViewModel {
        if tag == 1 {
            return RoundLevelViewModel(title: "Ù", image: nil, sourceImgView: nil)
        } else {
            return RoundLevelViewModel(title: "Đền", image: nil, sourceImgView: nil)
        }
    }
}
