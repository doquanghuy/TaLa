//
//  RuleSwitchTableViewCell.swift
//  TaLa
//
//  Created by huydoquang on 12/26/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

protocol RuleSwitchTableViewCellDelegate: class {
    func ruleSwitchChange(with ruleSwitchType: RulesSwitch, to value: Bool)
}

class RuleSwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var ruleName: UILabel!
    @IBOutlet weak var ruleSwitch: UISwitch!
    private var viewModel: RuleSwitchTableViewCellViewModelInterface!
    weak var delegate: RuleSwitchTableViewCellDelegate?
    
    @IBAction func switchRule(_ sender: UISwitch) {
        self.viewModel.changeValue(to: ruleSwitch.isOn)
    }
    
    func configure(with viewModel: RuleSwitchTableViewCellViewModelInterface, and delegate: RuleSwitchTableViewCellDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        
        self.viewModel.isOn.bind {[weak self] (value) in
            guard let this = self else { return }
            self?.delegate?.ruleSwitchChange(with: this.viewModel.ruleSwitchType, to: value)
            self?.ruleSwitch.isOn = value
        }
        self.viewModel.nameRule.bind {[weak self] (value) in
            self?.ruleName.text = value
        }
        
        self.viewModel.parse()
    }
}
