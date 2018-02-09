//
//  RoundResultViewModel.swift
//  TaLa
//
//  Created by huydoquang on 2/1/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol RoundResultViewModelInterface {
    func roundResultTableViewCellViewModel(at indexPath: IndexPath) -> RoundResultTableViewCellModelInterface?
}

class RoundResultViewModel: RoundResultViewModelInterface {
    private var originalPlayers: [Player]
    private var tempPlayers: [Player]
    private var rule: Rule
    
    init(originalPlayers: [Player], tempPlayers: [Player], rule: Rule) {
        self.originalPlayers = originalPlayers
        self.tempPlayers = tempPlayers
        self.rule = rule
    }
    
    func roundResultTableViewCellViewModel(at indexPath: IndexPath) -> RoundResultTableViewCellModelInterface? {
        let originalPlayer = self.originalPlayers[indexPath.row]
        let tempPlayer = self.tempPlayers[indexPath.row]
        
        return RoundResultTableViewCellModelFactory.factory().init(originalPlayer: originalPlayer, tempPlayer: tempPlayer, rule: self.rule)
    }
}
