//
//  RuleViewModel.swift
//  TaLa
//
//  Created by huydoquang on 12/26/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

//MARK: - RuleDataProviderInterface

protocol RuleDataProviderInterface {
    func ruleModelAtIndexPath(at indexPath: IndexPath) -> AnyObject?
    func numberOfSections() -> Int
    func numberOfRow(at section: Int) -> Int
    func isRuleSwitch(at indexPath: IndexPath) -> Bool
    func title(of section: Int) -> String
}

class RuleDataProvider: RuleDataProviderInterface {
    lazy private var tempRule: Rule? = {
        return GameManager.shared.currentGame?.rule?.temp as? Rule
    }()

    lazy private var dataSource: [[Rules]] = [[RulesSwitch.swap, RulesSwitch.reverse], [RulesValue.winAll, RulesValue.circleWin, RulesValue.dryWin, RulesValue.winLost, RulesValue.eatFirstCard, RulesValue.eatSecondCard, RulesValue.eatThirdCard, RulesValue.eatLastCard, RulesValue.notEat]]

    func ruleModelAtIndexPath(at indexPath: IndexPath) -> AnyObject? {
        guard let rule = self.tempRule else { return nil }
        let ruleSection = self.dataSource[indexPath.section]
        let ruleAtRow = ruleSection[indexPath.row]
        if let ruleSwitch = ruleAtRow as? RulesSwitch {
            return RuleSwitchTableViewCellViewModel(ruleType: ruleSwitch, rule: rule)
        } else if let ruleValue = ruleAtRow as? RulesValue {
            return RuleTableViewCellViewModel(ruleType: ruleValue, rule: rule)
        }
        return nil
    }
    
    func numberOfSections() -> Int {
        return self.dataSource.count
    }
    
    func numberOfRow(at section: Int) -> Int {
        return self.dataSource[section].count
    }
    
    func isRuleSwitch(at indexPath: IndexPath) -> Bool {
        return self.dataSource[indexPath.section][indexPath.row] is RulesSwitch
    }
    
    func title(of section: Int) -> String {
        if section == 0 {
            return "Switch To Change"
        } else {
            return "Click To Change"
        }
    }
}

//MARK: - RuleViewModelInterface

protocol RuleViewModelInterface {
    var baseMoney: Dynamic<String?> {get}
    
    func loadBaseMoney()
    func didLoad()
    func textFieldDidChange(text: String?)
    @discardableResult
    func save() -> Bool
    func reset()
    func changeRule(rule: Rules, to value: Any)
}

class RuleViewModel: RuleViewModelInterface {
    var baseMoney: Dynamic<String?> = Dynamic("")
    
    lazy private var tempRule: Rule? = {
        return GameManager.shared.currentGame?.rule?.temp as? Rule
    }()
    
    func textFieldDidChange(text: String?) {
        guard let number = text?.replacingOccurrences(of: ".", with: "") else {
            self.baseMoney.value = "0"
            return
        }
        if let intVal = Int64(number) {
            self.baseMoney.value = String.formattedNumber(from: intVal)
            self.changeRule(rule: RulesValue.baseMoney, to: intVal)
        }
    }
    
    func didLoad() {
        guard GameManager.shared.currentGame?.rule == nil else { return }
        let rule = Rule(context: CoreDataContext.main.context)
        rule.createdAt = Date()
        GameManager.shared.currentGame?.rule = rule
        Constants.CoreData.coreDataStack.saveContext()
    }
    
    func loadBaseMoney() {
        let baseMoney = self.tempRule?.baseMoney ?? 0
        let baseMoneyStr = String.formattedNumber(from: baseMoney)
        self.baseMoney.value = "\(baseMoneyStr)"
    }
    
    @discardableResult func save() -> Bool {
        guard Constants.CoreData.coreDataStack.saveChildContext() else {
            return false
        }
        guard Constants.CoreData.coreDataStack.saveContext() else {
            return false
        }
        return true
    }

    func reset() {
        Constants.CoreData.coreDataStack.childContext.reset()
    }
    
    func changeRule(rule: Rules, to value: Any) {
        guard let keyPath = rule.keyPath else { return }
        self.tempRule?.setValue(value, forKeyPath: keyPath)
    }
}
