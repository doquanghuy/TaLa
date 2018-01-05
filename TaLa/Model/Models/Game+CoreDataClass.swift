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
    static func game(at createdAt: Date) -> Game? {
        let context = CoreDataContext.main.context
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "%K == %@", #keyPath(Game.createdAt), createdAt as CVarArg)
        do {
            return try context.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Error Fetch Result Player: \(error.localizedDescription)")
            return nil
        }
    }
}
