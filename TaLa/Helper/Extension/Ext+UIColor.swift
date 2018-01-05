//
//  Ext+UIColor.swift
//  TaLa
//
//  Created by huydoquang on 12/23/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(cgColor: UIColor.gray.cgColor)
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    static var lightBlue = UIColor(hex: "1DE8FF")
    
    static var backgroundColor = UIColor(r: 0.0, g: 0.0, b: 0.0, alpha: 0.8)
}
