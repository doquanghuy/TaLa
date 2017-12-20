//
//  Game+CoreDataProperties.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var id: Int16
    @NSManaged public var rounds: NSSet?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for rounds
extension Game {

    @objc(addRoundsObject:)
    @NSManaged public func addToRounds(_ value: Round)

    @objc(removeRoundsObject:)
    @NSManaged public func removeFromRounds(_ value: Round)

    @objc(addRounds:)
    @NSManaged public func addToRounds(_ values: NSSet)

    @objc(removeRounds:)
    @NSManaged public func removeFromRounds(_ values: NSSet)

}

// MARK: Generated accessors for players
extension Game {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}
