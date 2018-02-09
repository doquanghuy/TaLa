//
//  RuleSwitchTableViewCellViewModel.swift
//  TaLa
//
//  Created by huydoquang on 12/27/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import Foundation

protocol RuleSwitchTableViewCellViewModelInterface {
    var isOn: Dynamic<Bool> { get }
    var nameRule: Dynamic<String> { get }
    var ruleSwitchType: RulesSwitch { get }
    func changeValue(to value: Bool)
    func parse()
}

class RuleSwitchTableViewCellViewModel: RuleSwitchTableViewCellViewModelInterface {
    var isOn: Dynamic<Bool> = Dynamic(true)
    var nameRule: Dynamic<String> = Dynamic("")
    var ruleSwitchType: RulesSwitch
    var rule: Rule
    
    init(ruleType: RulesSwitch, rule: Rule) {
        self.ruleSwitchType = ruleType
        self.rule = rule
    }
    
    func changeValue(to value: Bool) {
        self.isOn.value = value
    }
    
    func parse() {
        if let keyPath = ruleSwitchType.keyPath {
            let value = rule.value(forKeyPath: keyPath) as? Bool ?? true
            self.isOn.value = value
        }
        self.nameRule.value = ruleSwitchType.contentDisplay
    }
}
