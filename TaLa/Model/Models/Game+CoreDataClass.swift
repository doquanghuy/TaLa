//
//  Game+CoreDataClass.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData


public class Game: NSManagedObject {
    var currentRound: Int? {
        let context = CoreDataContext.main.context
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Game")
        fetchRequest.resultType = .countResultType
        do {
            return try context.fetch(fetchRequest).first?.intValue
        } catch let error as NSError {
            print("Error Fetch Result Player: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func game(at id: String) -> Game? {
        let context = CoreDataContext.main.context
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Error Fetch Result Player: \(error.localizedDescription)")
            return nil
        }
    }
}
