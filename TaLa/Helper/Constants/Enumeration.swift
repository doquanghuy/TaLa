//
//  Enumeration.swift
//  TaLa
//
//  Created by huydoquang on 12/22/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit
import CoreData

enum BaseResult {
    case success, fail
}

enum ImageSourceType: Int {
    case library = 1, camera
}

enum CoreDataContext {
    case main, child
    
    var context: NSManagedObjectContext {
        switch self {
        case .main:
            return Constants.CoreData.coreDataStack.managedContext
        default:
            return Constants.CoreData.coreDataStack.childContext
        }
    }
}

protocol Rules {
    var contentDisplay: String {get}
    var keyPath: String? {get}
}

enum RulesSwitch: Rules {
    case winLost, dryWin, circleWin, eatLast, eatEachRound, send, reverse, swap

    var contentDisplay: String {
        switch self {
        case .circleWin:
            return "Ù Tròn"
        case .dryWin:
            return "Ù Khan"
        case .eatEachRound:
            return "Ăn từng cây"
        case .eatLast:
            return "Ăn cây chốt"
        case .reverse:
            return "Ngược chiều kim đồng hồ"
        case .send:
            return "Gửi bài"
        case .swap:
            return "Đổi chỗ"
        default:
            return "Ù Đền"
        }
    }
    
    var keyPath: String? {
        switch self {
        case .reverse:
            return "isAntiClockWise"
        case .swap:
            return "enableSwap"
        case .circleWin:
            return nil
        case .dryWin:
            return nil
        case .eatEachRound:
            return nil
        case .eatLast:
            return nil
        default:
            return nil
        }
    }
}

enum RulesValue: Rules {
    case eatFirstCard, eatSecondCard, eatThirdCard, winLost, winAll, circleWin, dryWin, eatLastCard, notEat, baseMoney
    
    var contentDisplay: String {
        switch self {
        case .circleWin:
            return "Ù Tròn"
        case .dryWin:
            return "Ù Khan"
        case .winAll:
            return "Ù"
        case .eatFirstCard:
            return "Ăn Cây 1"
        case .eatSecondCard:
            return "Ăn Cây 2"
        case .eatThirdCard:
            return "Ăn Cây 3"
        case .eatLastCard:
            return "Ăn Cây Chốt"
        case .baseMoney:
            return "Mức Cược"
        case .winLost:
            return "Ù Đền"
        default:
            return "Móm"
        }
    }
    
    var keyPath: String? {
        switch self {
        case .circleWin:
            return "circleWin"
        case .dryWin:
            return "dryWin"
        case .winAll:
            return "winAll"
        case .eatFirstCard:
            return "eatFirstCard"
        case .eatSecondCard:
            return "eatSecondCard"
        case .eatThirdCard:
            return "eatThirdCard"
        case .eatLastCard:
            return "eatLastCard"
        case .baseMoney:
            return "baseMoney"
        case .winLost:
            return "winLost"
        default:
            return "notEat"
        }
    }
}


enum Result {
    case winLost, winAll, normal(numberNotEat: Int)
}

enum EatTypes: Int {
    case normal, last
    
    var color: UIColor {
        switch self {
        case .normal:
            return .lightGray
        default:
            return .orange
        }
    }    
}

enum PlayerResult: Int {
    case none
    case first
    case second
    case third
    case forth
    case notEat
    case win
    case lost
    case winAll
    case lostAll
    case winCircle
    case lostCircle
    case winAllCircle
    case lostAllCircle
    case winDry
    case lostDry
    
    func score(round: Round) -> Int16? {
        guard let rule = GameManager.shared.currentGame?.rule else {return nil}
        switch self {
        case .first:
            let loserResults = [round.resultPlayer1, round.resultPlayer2, round.resultPlayer3, round.resultPlayer4]
                .flatMap {PlayerResult(rawValue: Int($0))}
                .filter {$0 != self}
            return loserResults.reduce(0, {(total, loserResult) -> Int16 in
                return total - loserResult.score(round: round)!
            })
        case .second:
            return -1
        case .third:
            return -2
        case .forth:
            return -3
        case .notEat:
            return -4
        case .win:
            return rule.winLost * rule.winAll
        case .lost:
            return -(rule.winLost * rule.winAll)
        case .winAll:
            return rule.winAll
        case .lostAll:
            return -(rule.winAll / 3)
        case .winCircle:
            return rule.circleWin * rule.winAll
        case .lostCircle:
            return -rule.circleWin * rule.winAll
        case .winAllCircle:
            return rule.circleWin * rule.winAll
        case .lostAllCircle:
            return rule.circleWin * rule.winAll / 3
        case .winDry:
            return rule.dryWin * rule.winAll
        case .lostDry:
            return (-rule.dryWin * rule.winAll) / 3
        default:
            return nil
        }
    }
}

enum RoundResult: Int {
    case normal, winNormal, winCircleNormal, winDry, winLost, winCircleLost
    
    static let allCases: [RoundResult] = [.normal, .winNormal, .winCircleNormal, .winDry, .winLost, .winCircleLost]
}
