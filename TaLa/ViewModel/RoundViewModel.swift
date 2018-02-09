//
//  RoundViewModel.swift
//  TaLa
//
//  Created by huydoquang on 1/7/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import Foundation

protocol RoundViewModelInterface {
    var title: Dynamic<String>! {get}
    var roundResultViewModel: RoundResultViewModelInterface? {get}
    var round: Round? {get}
    var menuConfig: Dynamic<(enableSwap: Bool, isClockWise: Bool)> {get}
    
    func playerDidEat(eatingPlayerIndex: Int, atePlayerIndex: Int, completion: ((Int, EatTypes) -> Void)?)
    func playerDidEatLast(eatingPlayerIndex: Int, atePlayerIndex: Int, completion: ((Int) -> Void)?)
    func didEndRoundWinLost(winPlayerIndex: Int, lostPlayerIndex: Int, isCircle: Bool, completion: (() -> Void)?)
    func didEndRoundWinAll(winPlayerIndex: Int, isCircle: Bool, isDry: Bool, completion: (() -> Void)?)
    func didEndRoundNormal(orderIndexs: [Int], notEatIndexs: [Int], completion: (() -> Void)?)
    
    func undoPlayerDidEat(eatingPlayerIndex: Int, atePlayerIndex: Int, completion: ((Int, EatTypes) -> Void)?)
    func undoPlayerDidEatLast(eatingPlayerIndex: Int, atePlayerIndex: Int, completion: ((Int) -> Void)?)
    func undoDidEndRoundWinLost(winPlayerIndex: Int, lostPlayerIndex: Int, isCircle: Bool, completion: (() -> Void)?)
    func undoDidEndRoundWinAll(winPlayerIndex: Int, isCircle: Bool, isDry: Bool, completion: (() -> Void)?)
    func undoDidEndRoundNormal(orderIndexs: [Int], notEatIndexs: [Int], completion: (() -> Void)?)

    func setup()
    @discardableResult
    func save() -> Bool
    func roundLevelViewModel(at tag: Int) -> RoundLevelViewModel
    func menuPressed()
    func changeDirection()
}

class RoundViewModel: RoundViewModelInterface {
    var menuConfig: Dynamic<(enableSwap: Bool, isClockWise: Bool)> = Dynamic((false, false))
    var title: Dynamic<String>! = Dynamic("")
    
    var roundResultViewModel: RoundResultViewModelInterface? {
        guard let originalPlayers = GameManager.shared.currentGame?.players?.sorted(by: {$0.id < $1.id}), let rule = GameManager.shared.currentGame?.rule else {return nil}
        let originalPlayersSorted = originalPlayers.sorted {($0.score - ($0.temp as! Player).score) < ($1.score - ($1.temp as! Player).score)}
        let tempPlayers = originalPlayersSorted.flatMap {$0.temp as? Player}
        return RoundResultViewModel(originalPlayers: originalPlayersSorted, tempPlayers: tempPlayers, rule: rule)
    }
    
    lazy var round: Round? = {
        let round = Round(context: Constants.CoreData.coreDataStack.childContext)
        round.game = GameManager.shared.currentGame?.temp as? Game
        round.id = Int16(round.game?.rounds?.count ?? 0 + 1)
        return round
    }()
    
    private lazy var rule: Rule = {
        return GameManager.shared.currentGame!.rule!
    }()
    
    private lazy var players: [Player] = {
        return GameManager.shared.currentGame?.players?
            .sorted {$0.id < $1.id}
            .flatMap {$0.temp as? Player} ?? []
    }()
    
    private lazy var numberEatingCardPlayers: [Int16] = {
        guard let round = self.round else { return [] }
        return [round.numberCardPlayer1Eat, round.numberCardPlayer2Eat, round.numberCardPlayer3Eat, round.numberCardPlayer4Eat]
    }()
    
    private lazy var numberEatingLastCardPlayers: [Int16] = {
        guard let round = self.round else { return [] }
        return [round.numberLastCardPlayer1Eat, round.numberLastCardPlayer2Eat, round.numberLastCardPlayer3Eat, round.numberLastCardPlayer4Eat]
    }()
    
    private lazy var playerResults: [Int16] = {
        guard let round = self.round else { return [] }
        return [round.resultPlayer1, round.resultPlayer2, round.resultPlayer3, round.resultPlayer4]
    }()
    
    fileprivate func undoResult(completion: (() -> Void)? = nil) {
        for index in 0..<self.playerResults.count {
            self.playerResults[index] = 0
        }
        completion?()
    }
    
    fileprivate func updateScore(isUndo: Bool) {
        guard let round = self.round else {return}
        let resultPlayers: [PlayerResult] = self.playerResults.flatMap {PlayerResult(rawValue: Int($0))}
        
        [1, 2, 3, 4].forEach {round.setValue(self.playerResults[$0 - 1], forKeyPath: "resultPlayer\($0)")}
        [1, 2, 3, 4].forEach {round.setValue(self.numberEatingCardPlayers[$0 - 1], forKeyPath: "numberCardPlayer\($0)Eat")}
        [1, 2, 3, 4].forEach {round.setValue(self.numberEatingLastCardPlayers[$0 - 1], forKeyPath: "numberLastCardPlayer\($0)Eat")}

        for playerIndex in 1...4 {
            let resultPlayer = resultPlayers[playerIndex - 1]
            let score = (resultPlayer.score(round: round) ?? 0) * (isUndo ? -1 : 1)
            self.players[playerIndex - 1].score += score
        }
    }
    
    fileprivate func updateScoreEating(eatingPlayer: Int, atePlayer: Int, eatType: EatTypes, times: Int, isUndo: Bool = false) {
        var score: Int16 = 0
        switch eatType {
        case .normal:
            if times == 1 {
                score = rule.eatFirstCard
            } else if times == 2 {
                score = rule.eatSecondCard
            } else {
                score = rule.eatThirdCard
            }
        default:
            score = rule.eatLastCard
        }
        if isUndo {
            self.players.filter {$0.id == eatingPlayer}.first?.score -= score
            self.players.filter {$0.id == atePlayer}.first?.score += score
        } else {
            self.players.filter {$0.id == eatingPlayer}.first?.score += score
            self.players.filter {$0.id == atePlayer}.first?.score -= score
        }
    }
}

extension RoundViewModel {
    func playerDidEat(eatingPlayerIndex: Int, atePlayerIndex: Int, completion: ((Int, EatTypes) -> Void)? = nil) {
        self.numberEatingCardPlayers[eatingPlayerIndex - 1] += 1
        let oldNumberCardEating = self.numberEatingCardPlayers[eatingPlayerIndex - 1] + self.numberEatingLastCardPlayers[eatingPlayerIndex - 1]
        let eatType: EatTypes = self.numberEatingLastCardPlayers[eatingPlayerIndex - 1] > 0 ? .last : .normal
        self.updateScoreEating(eatingPlayer: eatingPlayerIndex, atePlayer: atePlayerIndex, eatType: eatType, times: Int(oldNumberCardEating))
        completion?(Int(oldNumberCardEating), eatType)
    }
    
    func playerDidEatLast(eatingPlayerIndex: Int, atePlayerIndex: Int, completion: ((Int) -> Void)? = nil) {
        self.numberEatingLastCardPlayers[eatingPlayerIndex - 1] += 1
        let oldNumberCardEating = self.numberEatingCardPlayers[eatingPlayerIndex - 1] + self.numberEatingLastCardPlayers[eatingPlayerIndex - 1]
        self.updateScoreEating(eatingPlayer: eatingPlayerIndex, atePlayer: atePlayerIndex, eatType: .last, times: Int(oldNumberCardEating))
        completion?(Int(oldNumberCardEating))
    }
    
    func didEndRoundWinLost(winPlayerIndex: Int, lostPlayerIndex: Int, isCircle: Bool, completion: (() -> Void)?) {
        self.playerResults[winPlayerIndex - 1] = Int16(isCircle ? PlayerResult.winCircle.rawValue : PlayerResult.win.rawValue)
        self.playerResults[lostPlayerIndex - 1] = Int16(isCircle ? PlayerResult.lostCircle.rawValue : PlayerResult.lost.rawValue)
        self.updateScore(isUndo: false)
        completion?()
    }
    
    func didEndRoundWinAll(winPlayerIndex: Int, isCircle: Bool, isDry: Bool, completion: (() -> Void)? = nil) {
        var playerWinResult: Int!
        var playerLostResult: Int!
        if isCircle {
            playerWinResult = PlayerResult.winCircle.rawValue
            playerLostResult = PlayerResult.lostCircle.rawValue
        } else if isDry {
            playerWinResult = PlayerResult.winDry.rawValue
            playerLostResult = PlayerResult.lostDry.rawValue
        } else {
            playerWinResult = PlayerResult.winAll.rawValue
            playerLostResult = PlayerResult.lostAll.rawValue
        }
        self.playerResults[winPlayerIndex - 1] = Int16(playerWinResult)
        for index in 0..<self.playerResults.count where index != winPlayerIndex - 1 {
            self.playerResults[index] = Int16(playerLostResult)
        }
        self.updateScore(isUndo: false)
        completion?()
    }
        
    func didEndRoundNormal(orderIndexs: [Int], notEatIndexs: [Int], completion: (() -> Void)?) {
        for (index, value) in orderIndexs.enumerated() {
            self.playerResults[value - 1] = Int16(index + 1)
        }
        for value in notEatIndexs {
            self.playerResults[value - 1] = Int16(PlayerResult.notEat.rawValue)
        }
        self.updateScore(isUndo: false)
        completion?()
    }
}

extension RoundViewModel {
    func undoPlayerDidEat(eatingPlayerIndex: Int, atePlayerIndex: Int, completion: ((Int, EatTypes) -> Void)?) {
        let eatType: EatTypes = self.numberEatingLastCardPlayers[eatingPlayerIndex - 1] > 0 ? .last : .normal
        var oldNumberCardEating = self.numberEatingCardPlayers[eatingPlayerIndex - 1] + self.numberEatingLastCardPlayers[eatingPlayerIndex - 1]

        self.updateScoreEating(eatingPlayer: eatingPlayerIndex, atePlayer: atePlayerIndex, eatType: eatType, times: Int(oldNumberCardEating), isUndo: true)
        self.numberEatingCardPlayers[eatingPlayerIndex - 1] -= 1
        oldNumberCardEating -= 1
        completion?(Int(oldNumberCardEating), eatType)
    }
    
    func undoPlayerDidEatLast(eatingPlayerIndex: Int, atePlayerIndex: Int, completion: ((Int) -> Void)?) {
        var oldNumberCardEating = self.numberEatingCardPlayers[eatingPlayerIndex - 1] + self.numberEatingLastCardPlayers[eatingPlayerIndex - 1]

        self.updateScoreEating(eatingPlayer: eatingPlayerIndex, atePlayer: atePlayerIndex, eatType: .last   , times: Int(oldNumberCardEating), isUndo: true)
        self.numberEatingLastCardPlayers[eatingPlayerIndex - 1] -= 1
        oldNumberCardEating -= 1
        completion?(Int(oldNumberCardEating))
    }
    
    func undoDidEndRoundWinLost(winPlayerIndex: Int, lostPlayerIndex: Int, isCircle: Bool, completion: (() -> Void)?) {
        self.updateScore(isUndo: true)
        self.undoResult(completion: completion)
    }
    
    func undoDidEndRoundWinAll(winPlayerIndex: Int, isCircle: Bool, isDry: Bool, completion: (() -> Void)?) {
        self.updateScore(isUndo: true)
        self.undoResult(completion: completion)
    }
    
    func undoDidEndRoundNormal(orderIndexs: [Int], notEatIndexs: [Int], completion: (() -> Void)?) {
        self.updateScore(isUndo: true)
        self.undoResult(completion: completion)
    }
}

extension RoundViewModel {
    func setup() {
        self.title.value = String(format: Constants.String.roundVCTitle, self.round?.id ?? 0)
    }
    
    func roundLevelViewModel(at tag: Int) -> RoundLevelViewModel {
        return RoundLevelViewModel(title: "\(tag)", image: nil, sourceImgView: nil)
    }
    
    @discardableResult
    func save() -> Bool {
        guard Constants.CoreData.coreDataStack.saveChildContext() else {
            return false
        }
        guard Constants.CoreData.coreDataStack.saveContext() else {
            return false
        }
        return true
    }
    
    func menuPressed() {
        self.menuConfig.value = (self.rule.enableSwap, self.rule.isAntiClockWise)
    }
    
    func changeDirection() {
        self.rule.isAntiClockWise = !self.rule.isAntiClockWise
        self.save()
    }
}
