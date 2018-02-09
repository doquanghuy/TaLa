//
//  Player+CoreDataClass.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData


public class Player: NSManagedObject {
    static func player(at index: Int, on contextType: CoreDataContext) -> Player? {
        guard let currentGame = GameManager.shared.currentGame else {return nil}
        let context = contextType.context
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "%K == %@ && %K == %@", #keyPath(Player.id), "\(index)", #keyPath(Player.game), currentGame)
        do {
            return try context.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Error Fetch Result Player: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func playerExisted(at index: Int) -> Bool {
        return Player.player(at: index, on: .main) != nil
    }
    
    static func nextPlayerIndex(currentId: Int) -> Int {
        guard let rule = GameManager.shared.currentGame?.rule else {return 0}
        if rule.isAntiClockWise {
            let nextId = currentId + 1
            return nextId <= 4 ? nextId : nextId - 4
        } else {
            let nextId = currentId - 1
            return nextId >= 1 ? nextId : 4
        }
    }
}
