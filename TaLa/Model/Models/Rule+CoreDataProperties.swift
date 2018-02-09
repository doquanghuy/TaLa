//
//  Rule+CoreDataProperties.swift
//  TaLa
//
//  Created by huydoquang on 12/27/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData


extension Rule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rule> {
        return NSFetchRequest<Rule>(entityName: "Rule")
    }

    @NSManaged public var baseMoney: Int64
    @NSManaged public var circleWin: Int16
    @NSManaged public var dryWin: Int16
    @NSManaged public var eatFirstCard: Int16
    @NSManaged public var eatLastCard: Int16
    @NSManaged public var eatSecondCard: Int16
    @NSManaged public var eatThirdCard: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var winAll: Int16
    @NSManaged public var winLost: Int16
    @NSManaged public var notEat: Int16
    @NSManaged public var enableSwap: Bool
    @NSManaged public var isAntiClockWise: Bool
    @NSManaged public var games: Game?
}
