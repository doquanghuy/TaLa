//
//  History.swift
//  TaLa
//
//  Created by huydoquang on 2/7/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import Foundation

class History {
    var id: Int16 = 0
    var playerScores: [Int16] = []
    var playerDescriptions: [String] = []
    private lazy var rule: Rule? = {
        return GameManager.shared.currentGame?.rule
    }()
    
    init(round: Round) {
        self.id = round.id
        self.playerScores = self.playersScore(round: round)
        self.playerDescriptions = Array(repeating: "", count: 4)
    }
    
    func playersScore(round: Round) -> [Int16] {
        let numberCards = [round.numberCardPlayer1Eat, round.numberCardPlayer2Eat, round.numberCardPlayer3Eat, round.numberCardPlayer4Eat]
        let numberLastCards = [round.numberLastCardPlayer1Eat, round.numberLastCardPlayer2Eat, round.numberLastCardPlayer3Eat, round.numberLastCardPlayer4Eat]
        var playerScores: [Int16] = Array(repeating: 0, count: 4)
        for index in 1...4 {
            let eatScore = self.eatCardScore(round: round, totalCard: Int(numberCards[index - 1]))
            let eatLastCardScore = self.eatLastCardScore(round: round, totalCard: Int(numberLastCards[index - 1]))
            playerScores[index - 1] += eatScore + eatLastCardScore + self.resultScore(round: round, index: index)
            playerScores[Player.nextPlayerIndex(currentId: index) - 1] -= eatScore + eatLastCardScore
        }
        return playerScores
    }
    
    private func eatCardScore(round: Round, totalCard: Int) -> Int16 {
        guard let rule = rule else {return 0}
        var playerScore: Int16 = 0
        var eatCardsRule = [rule.eatFirstCard, rule.eatSecondCard, rule.eatThirdCard]
        for numberCard in 0..<totalCard {
            playerScore += eatCardsRule[numberCard]
        }
        return playerScore
    }
    
    private func eatLastCardScore(round: Round, totalCard: Int) -> Int16 {
        guard let rule = rule else {return 0}
        var playerScore: Int16 = 0
        for _ in 0..<totalCard {
            playerScore += rule.eatLastCard
        }
        return playerScore
    }
    
    private func resultScore(round: Round, index: Int) -> Int16 {
        let resultPlayers: [PlayerResult] = [round.resultPlayer1, round.resultPlayer2, round.resultPlayer3, round.resultPlayer4].flatMap {PlayerResult(rawValue: Int($0))}
        let resultPlayer = resultPlayers[index - 1]
        return resultPlayer.score(round: round) ?? 0
    }
}
