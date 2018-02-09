//
//  RuleTableViewCell.swift
//  TaLa
//
//  Created by huydoquang on 12/26/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

protocol RuleTableViewCellDelegate: class {
    func ruleDidChange(with ruleType: RulesValue, and value: Double)
}

class RuleTableViewCell: UITableViewCell {
    @IBOutlet weak var ruleName: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var prefixLabel: UILabel!
    
    private var viewModel: RuleTableViewCellViewModelInterface!
    private weak var delegate: RuleTableViewCellDelegate?
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        self.viewModel.changeValue(to: sender.value)
    }
    
    func configure(with viewModel: RuleTableViewCellViewModelInterface, and delegate: RuleTableViewCellDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.viewModel.prefix.bind { (value) in
            self.prefixLabel.text = value
        }
        
        self.viewModel.nameRule.bind {[weak self] (value) in
            self?.ruleName.text = value
        }
        self.viewModel.value.bind {[weak self] (value) in
            guard let this = self else { return }
            this.delegate?.ruleDidChange(with: this.viewModel.ruleType, and: value)
            this.stepper.value = value
            this.valueLabel.text = "\(Int(value))"
        }
        
        self.viewModel.parse()
    }
}
