//
//  RoundResultTableViewCell.swift
//  TaLa
//
//  Created by huydoquang on 2/1/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class RoundResultTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roundScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var bottomSeparatorView: UIView!
        
    func parse(viewModel: RoundResultTableViewCellModelInterface, isLastCell: Bool) {
        self.avatarImgView.makeViewCircle(maskToBound: true)
        self.avatarImgView.image = UIImage(contentsOfFile: viewModel.avatarImg ?? "")
        self.nameLabel.text = viewModel.name
        self.roundScoreLabel.text = viewModel.roundScore
        self.totalScoreLabel.text = viewModel.totalScore
        self.bottomSeparatorView.backgroundColor = isLastCell ? self.backgroundColor : .white
    }
}
