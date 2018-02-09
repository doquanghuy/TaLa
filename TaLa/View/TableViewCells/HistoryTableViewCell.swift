//
//  HistoryTableViewCell.swift
//  TaLa
//
//  Created by huydoquang on 2/7/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet var scoreButtons: [UIButton]!
    @IBOutlet weak var highestScorePlayerImgView: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(viewModel: HistoryTableViewCellModelInterface, indexPath: IndexPath) {
        self.roundLabel.text = viewModel.roundId
        for (index, button) in scoreButtons.enumerated() {
            let scoreText = "\(viewModel.playerScores[index])"
            button.setTitle(scoreText, for: .normal)
        }
        if let highestPlayerImgPath = viewModel.highestScorePlayerImgPath {
            self.highestScorePlayerImgView.image = UIImage(contentsOfFile: highestPlayerImgPath)
        }
        self.topBorderView.isHidden = !(indexPath.row == 0)
    }
    
}
