//
//  EatingViewModel.swift
//  TaLa
//
//  Created by huydoquang on 1/17/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

struct LinkEatingViewModel {
    var eatType: EatTypes
    var times: Int
    
    var color: UIColor {
        return eatType.color
    }
    
    var content: String {
        switch eatType {
        case .normal:
            return normalContent(times: times)
        default:
            return "Ăn cây chốt"
        }
    }
    
    private func normalContent(times: Int) -> String {
        switch times {
        case 1:
            return "Ăn cây thứ nhất"
        case 2:
            return "Ăn cây thứ hai"
        default:
            return "Ăn cây thứ ba"
        }
    }
}
