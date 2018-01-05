//
//  Enumeration.swift
//  TaLa
//
//  Created by huydoquang on 12/22/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import Foundation
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
            return "Đảo vòng"
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
            return "enableReverse"
        case .send:
            return "enableSend"
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
    case eatFirstCard, eatSecondCard, eatThirdCard, winLost, winAll, circleWin, dryWin, eatLastCard, baseMoney
    
    var contentDisplay: String {
        switch self {
        case .circleWin:
            return "Ù Tròn"
        case .dryWin:
            return "Ù Khan"
        case .winAll:
            return "Ù"
        case .eatFirstCard:
            return "Ăn Cây Thứ Nhất"
        case .eatSecondCard:
            return "Ăn Cây Thứ Hai"
        case .eatThirdCard:
            return "Ăn Cây Thứ Ba"
        case .eatLastCard:
            return "Ăn Cây Chốt"
        case .baseMoney:
            return "Mức Cược"
        default:
            return "Ù Đền"
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
        default:
            return "winLost"
        }
    }
}
