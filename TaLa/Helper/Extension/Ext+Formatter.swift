//
//  Ext+Formatter.swift
//  TaLa
//
//  Created by huydoquang on 2/2/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import Foundation

extension Formatter {
    static var defaultNumberFormatter: NumberFormatter = {
        let separator = "."
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        return formatter
    }()
}
