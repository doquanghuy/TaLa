//
//  HistoryViewController.swift
//  TaLa
//
//  Created by huydoquang on 2/4/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {
    let identifier = String(describing: HistoryTableViewCell.self)
    @IBOutlet weak var headerView: HistoryHeaderTableView!
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: HistoryViewModelInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    private func setupUI() {

    }
    
    private func setupData() {
        self.viewModel = HistoryViewModel()
        self.viewModel.didLoadHistories.bind {[weak self] (histories) in
            self?.tableView.reloadData()
        }
    }
    
    private func reloadData() {
        self.viewModel.loadHistories()
        self.headerView.reload()
    }
}
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HistoryTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let historyTableViewCellModel = self.viewModel.historyCellViewModel(at: indexPath), let cell = cell as? HistoryTableViewCell {
            cell.setup(viewModel: historyTableViewCellModel, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
