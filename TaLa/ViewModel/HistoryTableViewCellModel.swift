//
//  HistoryTableViewCellModel.swift
//  TaLa
//
//  Created by huydoquang on 2/8/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import Foundation

protocol HistoryTableViewCellModelInterface {
    var roundId: String {get}
    var playerScores: [Int64] {get}
    var descriptions: [String] {get}
    var imagePaths: [String?] {get}
    var highestScorePlayerImgPath: String? {get}
}

class HistoryTableViewCellModel: HistoryTableViewCellModelInterface {
    var playerScores: [Int64]
    var roundId: String
    var imagePaths: [String?]
    var descriptions: [String]
    var highestScorePlayerImgPath: String?
    
    init?(history: History) {
        guard let rule = GameManager.shared.currentGame?.rule else {return nil}
        let players = GameManager.shared.currentGame!.players!.sorted {$0.id < $1.id}
        self.roundId = "\(history.id)"
        self.descriptions = history.playerDescriptions
        self.playerScores = history.playerScores.flatMap {Int64($0) * rule.baseMoney}
        self.imagePaths = players
            .flatMap {TLFileManager.shared.fullImagePath(from: $0.image ?? "")}
        if let maxScore = playerScores.max(), let index = playerScores.index(of: maxScore), let imageName =  players[index].image {
            self.highestScorePlayerImgPath = TLFileManager.shared.fullImagePath(from: imageName)
        }
    }
}
