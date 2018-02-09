//
//  Game+CoreDataProperties.swift
//  TaLa
//
//  Created by huydoquang on 12/27/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var id: String
    @NSManaged public var players: Set<Player>?
    @NSManaged public var rounds: Set<Round>?
    @NSManaged public var rule: Rule?

}

// MARK: Generated accessors for players
extension Game {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: Set<Player>)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: Set<Player>)

}

// MARK: Generated accessors for rounds
extension Game {

    @objc(addRoundsObject:)
    @NSManaged public func addToRounds(_ value: Round)

    @objc(removeRoundsObject:)
    @NSManaged public func removeFromRounds(_ value: Round)

    @objc(addRounds:)
    @NSManaged public func addToRounds(_ values: Set<Round>)

    @objc(removeRounds:)
    @NSManaged public func removeFromRounds(_ values: Set<Round>)

}
