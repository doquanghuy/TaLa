//
//  RoundLevelView.swift
//  TaLa
//
//  Created by huydoquang on 1/6/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class RoundLevelView: UIView {    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orderView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupFromXib()
    }
    
    func setup(with viewModel: RoundLevelViewModel) {
        self.imgView.image = viewModel.image
        self.titleLabel.text = viewModel.title
        self.titleLabel.textColor = UIColor.darkGray
        self.orderView.backgroundColor = .clear
        self.orderView.layer.cornerRadius = 5.0
        self.orderView.layer.borderColor = UIColor.darkGray.cgColor
        self.orderView.layer.borderWidth = 1.0
    }
}
