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
    
    static func formattedNumber(from number: Int64) -> String {
        return Formatter.defaultNumberFormatter.string(from: NSNumber(value: number)) ?? "0"
    }
}
