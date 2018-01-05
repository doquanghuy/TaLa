//
//  RuleHeaderTableView.swift
//  TaLa
//
//  Created by huydoquang on 1/3/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class RuleHeaderTableView: UITableViewHeaderFooterView {
    @IBOutlet weak var sectionName: UILabel!

    func configure(sectionName: String) {
        self.sectionName.text = sectionName
    }
}
