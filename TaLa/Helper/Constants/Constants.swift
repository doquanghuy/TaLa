//
//  Constants.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

struct Constants {
    struct CoreData {
        static let coreDataStack = CoreDataStack(modelName: "TaLa")
    }
    
    struct ObserverKeyPath {
        static let center = "center"
    }
    
    struct Folder {
        static let defaultImagesFolderName = "Images"
    }
    
    struct PersistentKeys {
        static let currentGameCreated = "currentGameCreated"
    }
    
    struct Segues {
        static let fromPlayerVCToRuleVC = "fromPlayerVCToRuleVC"
    }
}
