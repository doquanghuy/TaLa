//
//  Constants.swift
//  TaLa
//
//  Created by huydoquang on 12/20/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

struct Storyboard {
    var name: String
    var viewControllers: [String: String]
}

struct Constants {
    struct Storyboards {
        static let main = Storyboard(name: "Main", viewControllers: ["RoundViewController": "RoundViewController", "PlayerViewController": "PlayerViewController", "RuleViewController": "RuleViewController", "CreatePlayerViewController": "CreatePlayerViewController", "EditPlayerViewController": "EditPlayerViewController"])
    }
    
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
        static let gameId = "currentGameCreated"
    }
    
    struct Segues {
        static let fromPlayerVCToRuleVC = "fromPlayerVCToRuleVC"
        static let fromRuleVCToRoundVC = "fromRuleVCToRoundVC"
        static let fromRoundVCToEditPlayerVC = "fromRoundVCToEditPlayerVC"
    }
    
    struct String {
        static let win = "Ù"
        static let lost = "Đền"
        static let selectWinType = "Ù Tròn?"
        static let yes = "Đúng"
        static let no = "Sai"
        static let winAll = "Ù"
        static let winCircle = "Ù tròn"
        static let roundVCTitle = "Ván thứ %d"
        static let changeRule = "Đổi luật chơi"
        static let changePosition = "Đổi chỗ"
        static let changeDirection = "Đảo vòng"
        static let endGame = "Kết thúc"
        static let cancel = "Huỷ"
        static let ok = "Đồng ý"
        static let endGameTitle = "Kết thúc Game?"
        static let endGameMessage = "Khi kết thúc Game, mọi data sẽ được lưu lại và ứng dụng sẽ tự động tạo một Game mới. Bạn có muốn tiếp tục không?"
        static let changeDirectionTitle = "Đảo vòng?"
        static let changeDirectionMessage = "Khi bạn nhấn \"Đồng ý\", ứng dụng sẽ lưu lại và sử dụng cho các ván tiếp theo. Bạn có muốn tiếp tục không?"
    }
    
    struct Image {
        static let rotateLeft = "rotate_left"
        static let rotateRight = "rotate_right"
        static let round = "round"
        static let roundSelected = "round_selected"
        static let chart = "chart"
        static let chartSelected = "chart_selected"
    }
}
