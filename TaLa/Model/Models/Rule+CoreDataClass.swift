//
//  Rule+CoreDataClass.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData


public class Rule: NSManagedObject {
    static func rule(at createdAt: Date) -> Rule? {
        let context = CoreDataContext.main.context
        let fetchRequest: NSFetchRequest<Rule> = Rule.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "%K == %@", #keyPath(Rule.createdAt), createdAt as CVarArg)
        do {
            return try context.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Error Fetch Result Player: \(error.localizedDescription)")
            return nil
        }
    }
}
