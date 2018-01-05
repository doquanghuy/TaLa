//
//  Ext+UIView.swift
//  TaLa
//
//  Created by huydoquang on 12/23/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

extension UIView {
    func makeViewCircle() {
        self.layer.cornerRadius = self.frame.width / 2.0
        self.layer.masksToBounds = true
    }
    
    func deactiveConstraints() {
        self.constraints.forEach {$0.isActive = false}
    }
}
