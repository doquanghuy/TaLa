//
//  Round+CoreDataProperties.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData


extension Round {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Round> {
        return NSFetchRequest<Round>(entityName: "Round")
    }

    @NSManaged public var idPlayerWinAll: Int16
    @NSManaged public var idPlayer1st: Int16
    @NSManaged public var idPlayer2nd: Int16
    @NSManaged public var idPlayer3rd: Int16
    @NSManaged public var idPlayer4th: Int16
    @NSManaged public var startTime: NSDate?
    @NSManaged public var endTime: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var game: Game?
    @NSManaged public var rule: Rule?

}
