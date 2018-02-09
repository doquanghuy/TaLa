//
//  HistoryHeaderTableViewModel.swift
//  TaLa
//
//  Created by huydoquang on 2/8/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import Foundation

protocol HistoryHeaderTableViewModelInterface {
    var playerScores: [Int64] {get}
    var imagePaths: [String?] {get}
    var highestScorePlayerImgPath: String? {get}
    
    func reload()
}

class HistoryHeaderTableViewModel: HistoryHeaderTableViewModelInterface {
    var playerScores: [Int64] = []
    var imagePaths: [String?] = []
    var highestScorePlayerImgPath: String?
    
    init() {
        self.reload()
    }
    
    func reload() {
        guard let game = GameManager.shared.currentGame, let players = game.players, let rule = game.rule else {return}
        let playersSorted = players.sorted {$0.id < $1.id}
        self.playerScores = playersSorted.flatMap {Int64($0.score) * rule.baseMoney}
        self.imagePaths = playersSorted.flatMap {TLFileManager.shared.fullImagePath(from: $0.image ?? "")}
    }
}
