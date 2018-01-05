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
        let context = contextType.context
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "%K == %@", #keyPath(Player.id), "\(index)")
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
}
