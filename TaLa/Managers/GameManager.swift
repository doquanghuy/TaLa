//
//  GameManager.swift
//  TaLa
//
//  Created by huydoquang on 12/21/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

class GameManager {
    static let shared = GameManager()
    
    private var playerFactory: PlayerFactory = PlayerFactoryImplement()
    private var playerEdit: PlayerEdit = PlayerEditImplement()
    var currentGame: Game?
    
    func startNewGame() {
        let currentGameCreated = PersistentManager.currentGameCreated!
        if let currentGame = Game.game(at: Date(timeIntervalSince1970: currentGameCreated)) {
            self.currentGame = currentGame
            return
        }
        self.currentGame = Game(context: Constants.CoreData.coreDataStack.managedContext)
        self.currentGame?.createdAt = Date()
        let players = playerFactory.createPlayers()
        self.currentGame?.players = Set(players)
        Constants.CoreData.coreDataStack.saveContext()
        PersistentManager.currentGameCreated = currentGameCreated
    }
    
    func endGame() {
        PersistentManager.currentGameCreated = nil
    }
    
    func createRule() -> Rule? {
        return nil
    }
    
    func editRule() -> Rule? {
        return nil
    }
    
    func editPlayer(withName name: String?, andImage image: UIImage?, andScore score: Int, at index: Int) {
        playerEdit.editPlayer(withName: name, andImage: image, andScore: score, at: index)
    }
    
    func swapPlayer(fromIndex: Int, toIndex: Int) {
        playerEdit.swapPlayer(fromIndex: fromIndex, toIndex: toIndex)
    }
    
    func save() -> Bool {
        return playerEdit.save()
    }
}
