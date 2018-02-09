//
//  RoundPlayerViewModel.swift
//  TaLa
//
//  Created by huydoquang on 1/15/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import Foundation

protocol RoundPlayerViewModelInterface {
    var imagePaths: Dynamic<[String?]> {get}
    var directionImageName: Dynamic<String> {get}
    
    func didLoad()
}

class RoundPlayerViewModel: RoundPlayerViewModelInterface {
    var imagePaths: Dynamic<[String?]> = Dynamic([])
    var directionImageName: Dynamic<String> = Dynamic("")
    lazy var rule: Rule = {
        return GameManager.shared.currentGame!.rule!
    }()
    
    func didLoad() {
        let players = GameManager.shared.currentGame?.players?.sorted {$0.id < $1.id}
        self.imagePaths.value = players?.flatMap {TLFileManager.shared.fullImagePath(from: $0.image ?? "")} ?? []
        self.directionImageName.value = rule.isAntiClockWise ? Constants.Image.rotateLeft : Constants.Image.rotateRight
    }
}
