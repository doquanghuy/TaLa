//
//  Ext+Date.swift
//  TaLa
//
//  Created by huydoquang on 1/7/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import Foundation

extension Date {
    static func duration(from start: Date, to end: Date) -> Double {
        return end.timeIntervalSince1970 - start.timeIntervalSince1970
    }
}
