//
//  RoundResultView.swift
//  TaLa
//
//  Created by huydoquang on 2/1/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class RoundResultView: UIView {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: RoundResultViewModelInterface! {
        didSet {
            self.tableView.reloadData()
        }
    }
    private let cellIdentifier = "RoundResultTableViewCell"
    
    init(frame: CGRect, viewModel: RoundResultViewModelInterface) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        let nib = UINib(nibName: String(describing: RoundResultTableViewCell.self), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}

extension RoundResultView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel == nil ? 0 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RoundResultTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellViewModel = self.viewModel.roundResultTableViewCellViewModel(at: indexPath) else {return}
        (cell as? RoundResultTableViewCell)?.parse(viewModel: cellViewModel, isLastCell: indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.bounds.height / CGFloat(tableView.numberOfRows(inSection: indexPath.section))
    }
}
