//
//  SetUpPlayerViewModel.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit
import CoreData

protocol SetUpPlayer {
    var didSwapPlayers: Dynamic<Bool> { get }
    var didSetUpPlayer: Dynamic<Bool> { get }
    var didSave: Dynamic<Bool> { get }
    
    init(forceCreate: Bool)
    func setupData(forceCreate: Bool)
    func setupPlayerInfo(withImage image: UIImage?, andName name: String?, andScore score: Int, at index: Int)
    func swapPlayer(fromIndex: Int, toIndex: Int)
    func save()
    func cancel()
    func player(at index: Int) -> Player?
}

class SetUpPlayerViewModel: SetUpPlayer {
    var didSwapPlayers: Dynamic<Bool> = Dynamic(false)
    var didSetUpPlayer: Dynamic<Bool> = Dynamic(false)
    var didSave: Dynamic<Bool> = Dynamic(false)
    
    required init(forceCreate: Bool) {
        self.setupData(forceCreate: forceCreate)
    }
    
    func setupData(forceCreate: Bool) {
        GameManager.shared.startNewGame(forceCreate: forceCreate)
    }
    
    func player(at index: Int) -> Player? {
        return Player.player(at: index, on: .main)?.temp as? Player
    }
    
    func setupPlayerInfo(withImage image: UIImage?, andName name: String?, andScore score: Int = 0, at index: Int) {
        GameManager.shared.editPlayer(withName: name, andImage: image, andScore: score, at: index)
        didSetUpPlayer.value = true
    }
    
    func swapPlayer(fromIndex: Int, toIndex: Int) {
        GameManager.shared.swapPlayer(fromIndex: fromIndex, toIndex: toIndex)
        didSwapPlayers.value = true
    }
    
    func save() {
        didSave.value = GameManager.shared.save()
    }
    
    func cancel() {
        //TODO
    }
}
