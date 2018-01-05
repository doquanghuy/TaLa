//
//  Ext+String.swift
//  TaLa
//
//  Created by huydoquang on 12/24/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import Foundation

extension String {
    static func playerNumber(with number: Int) -> String {
        return "Player \(number)"
    }
    
    func convertStringToNumberString(groupSize: Int) -> String {
        let separator = "."
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.groupingSize = groupSize
        formatter.usesGroupingSeparator = true
        formatter.secondaryGroupingSize = 2

        let number = self.replacingOccurrences(of: separator, with: "")
        if let doubleVal = Double(number) {
            let requiredString = formatter.string(from: NSNumber(value: doubleVal))
            return requiredString ?? "0"
        }
        return "0"
    }
}
