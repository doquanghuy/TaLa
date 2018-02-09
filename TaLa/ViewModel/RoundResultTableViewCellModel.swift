//
//  RoundResultTableViewCellModel.swift
//  TaLa
//
//  Created by huydoquang on 2/1/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol RoundResultTableViewCellModelInterface {
    var avatarImg: String? {get}
    var name: String? {get}
    var roundScore: String {get}
    var totalScore: String {get}
    init(originalPlayer: Player, tempPlayer: Player, rule: Rule)
}

class RoundResultTableViewCellModelFactory {
    static func factory() -> RoundResultTableViewCellModelInterface.Type {
        return RoundResultTableViewCellModel.self
    }
}

class RoundResultTableViewCellModel: RoundResultTableViewCellModelInterface {
    var avatarImg: String?
    var name: String?
    var roundScore: String
    var totalScore: String
    
    required init(originalPlayer: Player, tempPlayer: Player, rule: Rule) {
        if let imageName = originalPlayer.image, let fullPath = TLFileManager.shared.fullImagePath(from: imageName) {
            self.avatarImg = fullPath
        }
        self.name = originalPlayer.name
        self.totalScore = String.formattedNumber(from: Int64(tempPlayer.score) * rule.baseMoney)
        self.roundScore = String.formattedNumber(from:Int64(tempPlayer.score - originalPlayer.score) * rule.baseMoney)
    }
}
