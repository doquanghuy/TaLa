//
//  PersistentManager.swift
//  TaLa
//
//  Created by huydoquang on 12/26/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import Foundation

class PersistentManager {
    static var currentGameCreated: Double? {
        get {
            return UserDefaults.standard.object(forKey: Constants.PersistentKeys.currentGameCreated) as? Double ?? Date().timeIntervalSince1970
        } set(value) {
            if self.currentGameCreated != value {
                UserDefaults.standard.set(value, forKey: Constants.PersistentKeys.currentGameCreated)
            }
        }
    }
}
