//
//  PlayersViewModel.swift
//  TaLa
//
//  Created by huydoquang on 12/26/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import Foundation

protocol PlayersViewModelInterface {
    func player(at index: Int) -> Player?
}

class PlayersViewModel: PlayersViewModelInterface {
    func player(at index: Int) -> Player? {
        return Player.player(at: index, on: .main)
    }
}
