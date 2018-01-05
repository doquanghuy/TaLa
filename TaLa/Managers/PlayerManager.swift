//
//  PlayerManager.swift
//  TaLa
//
//  Created by huydoquang on 12/21/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit
import CoreData

protocol PlayerEdit {
    func editPlayer(withName name: String?, andImage image: UIImage?, andScore score: Int, at index: Int)
    func swapPlayer(fromIndex: Int, toIndex: Int)
    func save() -> Bool
}

class PlayerEditImplement: PlayerEdit {
    func editPlayer(withName name: String?, andImage image: UIImage?, andScore score: Int, at index: Int) {
        guard let player = Player.player(at: index, on: .main)?.temp as? Player else {
            return
        }
        if let image = image {
            if let imagePath = player.image {
                player.image = TLFileManager.shared.replaceFile(at: URL(fileURLWithPath: imagePath), with: image)?.path
            } else {
                player.image = TLFileManager.shared.addImage(with: image)?.path
            }
        } else {
            player.image = nil
        }
        player.name = name
    }
    
    func swapPlayer(fromIndex: Int, toIndex: Int) {
        guard let fromPlayer = Player.player(at: fromIndex, on: .main)?.temp as? Player, let toPlayer = Player.player(at: toIndex, on: .main)?.temp as? Player else {
            return
        }
        
        let tempName = fromPlayer.name
        let tempImage = fromPlayer.image
        let tempScore = fromPlayer.score
        
        fromPlayer.name = toPlayer.name
        fromPlayer.image = toPlayer.image
        fromPlayer.score = toPlayer.score
        
        toPlayer.name = tempName
        toPlayer.image = tempImage
        toPlayer.score = tempScore
    }
    
    @discardableResult func saveChildContext() -> Bool {
        return Constants.CoreData.coreDataStack.saveChildContext()
    }
    
    @discardableResult func saveMainContext() -> Bool {
        return Constants.CoreData.coreDataStack.saveContext()
    }
    
    @discardableResult func save() -> Bool {
        guard Constants.CoreData.coreDataStack.saveChildContext() else {
            return false
        }
        guard Constants.CoreData.coreDataStack.saveContext() else {
            return false
        }
        return true
    }
}

protocol PlayerFactory {
    func createPlayers() -> [Player]
}

class PlayerFactoryImplement: PlayerFactory {
    var players = [Player]()
    
    func createPlayers() -> [Player] {
        let context = Constants.CoreData.coreDataStack.managedContext
        
        for i in 1...4 {
            if let player = Player.player(at: i, on: .main) {
                players.append(player)
                continue
            }
            let player = Player(context: context)
            player.id = Int16(i)
            players.append(player)
        }
        
        Constants.CoreData.coreDataStack.saveContext()
        return players
    }
}
