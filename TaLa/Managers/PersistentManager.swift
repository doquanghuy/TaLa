//
//  PersistentManager.swift
//  TaLa
//
//  Created by huydoquang on 12/26/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import Foundation

class PersistentManager {
    static var currentGameId: String? {
        get {
            return UserDefaults.standard.object(forKey: Constants.PersistentKeys.gameId) as? String
        } set(value) {
            if self.currentGameId != value {
                UserDefaults.standard.set(value, forKey: Constants.PersistentKeys.gameId)
            }
        }
    }
}
