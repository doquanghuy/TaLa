//
//  Round+CoreDataProperties.swift
//  TaLa
//
//  Created by huydoquang on 1/20/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData


extension Round {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Round> {
        return NSFetchRequest<Round>(entityName: "Round")
    }

    @NSManaged public var endTime: Date?
    @NSManaged public var id: Int16
    @NSManaged public var startTime: Date?
    @NSManaged public var numberCardPlayer1Eat: Int16
    @NSManaged public var numberCardPlayer2Eat: Int16
    @NSManaged public var numberCardPlayer3Eat: Int16
    @NSManaged public var numberCardPlayer4Eat: Int16
    @NSManaged public var numberLastCardPlayer2Eat: Int16
    @NSManaged public var numberLastCardPlayer1Eat: Int16
    @NSManaged public var numberLastCardPlayer3Eat: Int16
    @NSManaged public var numberLastCardPlayer4Eat: Int16
    @NSManaged public var resultPlayer1: Int16
    @NSManaged public var resultPlayer2: Int16
    @NSManaged public var resultPlayer3: Int16
    @NSManaged public var resultPlayer4: Int16
    @NSManaged public var game: Game?
}
