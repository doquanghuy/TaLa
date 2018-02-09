//
//  RuleViewController.swift
//  TaLa
//
//  Created by huydoquang on 12/26/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

class RuleViewController: BaseViewController {

    @IBOutlet weak var baseMoneyTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: RuleViewModelInterface = RuleViewModel()
    private let dataProvider: RuleDataProviderInterface = RuleDataProvider()
    
    class var instance: RuleViewController {
        return UIStoryboard(name: Constants.Storyboards.main.name, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboards.main.viewControllers[self.name]!) as! RuleViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    private func setupUI() {
        let headerNib = UINib(nibName: String(describing: RuleHeaderTableView.self), bundle: nil)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: String(describing: RuleHeaderTableView.self))
        self.baseMoneyTextField.becomeFirstResponder()
        self.baseMoneyTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    private func setupData() {
        self.viewModel.baseMoney.bind {[weak self] (value) in
            self?.baseMoneyTextField.text = value
        }
        self.viewModel.didLoad()
        self.viewModel.loadBaseMoney()
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        self.viewModel.textFieldDidChange(text: textField.text)
    }
    
    @IBAction func processWhenClickLeftBarButtonItem(_ sender: Any) {
        self.viewModel.reset()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func processWhenClickRightBarButtonItem(_ sender: Any) {
        self.viewModel.save()
        self.performSegue(withIdentifier: Constants.Segues.fromRuleVCToRoundVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.definesPresentationContext = true
    }
    
    deinit {
        print("deinit")
    }
}

extension RuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
}

extension RuleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataProvider.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.numberOfRow(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.dataProvider.ruleModelAtIndexPath(at: indexPath)
        if self.dataProvider.isRuleSwitch(at: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RuleSwitchTableViewCell.self), for: indexPath) as! RuleSwitchTableViewCell
            cell.configure(with: cellViewModel as! RuleSwitchTableViewCellViewModel, and: self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RuleTableViewCell.self), for: indexPath) as! RuleTableViewCell
            cell.configure(with: cellViewModel as! RuleTableViewCellViewModel, and: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: RuleHeaderTableView.self)) as! RuleHeaderTableView
        view.configure(sectionName: self.dataProvider.title(of: section))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65.0
    }
}

extension RuleViewController: RuleSwitchTableViewCellDelegate {
    func ruleSwitchChange(with ruleSwitchType: RulesSwitch, to value: Bool) {
        self.viewModel.changeRule(rule: ruleSwitchType, to: value)
    }
}

extension RuleViewController: RuleTableViewCellDelegate {
    func ruleDidChange(with ruleType: RulesValue, and value: Double) {
        self.viewModel.changeRule(rule: ruleType, to: Int16(value))
    }
}
