//
//  Round+CoreDataClass.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//
//

import Foundation
import CoreData

public class Round: NSManagedObject {
    static func round(at id: Int16, on contextType: CoreDataContext) -> Round? {
        let context = contextType.context
        let fetchRequest: NSFetchRequest<Round> = Round.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "%K == %@", #keyPath(Round.id), "\(id)")
        do {
            return try context.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Error Fetch Result Player: \(error.localizedDescription)")
            return nil
        }
    }

    static func roundExisted(at id: Int16) -> Bool {
        return Round.round(at: id, on: .main) != nil
    }
}
