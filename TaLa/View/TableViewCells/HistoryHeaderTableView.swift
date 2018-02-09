//
//  HistoryHeaderTableView.swift
//  TaLa
//
//  Created by huydoquang on 2/8/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class HistoryHeaderTableView: UIView {
    @IBOutlet var playerImgViews: [UIImageView]!
    @IBOutlet weak var highestScorePlayerImgView: UIImageView!
    @IBOutlet var playerScoreLabels: [UILabel]!
    private var viewModel: HistoryHeaderTableViewModelInterface = HistoryHeaderTableViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromXib()
        self.reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupFromXib()
    }
    
    func reload() {
        self.viewModel.reload()
        let playerImgViewsSorted = self.playerImgViews.sorted {$0.tag < $1.tag}
        let playerScoreLabelsSorted = self.playerScoreLabels.sorted {$0.tag < $1.tag}
        for (index, imgView) in playerImgViewsSorted.enumerated() {
            imgView.image = UIImage(contentsOfFile: viewModel.imagePaths[index] ?? "")
        }
        
        for (index, label) in playerScoreLabelsSorted.enumerated() {
            label.text = "\(viewModel.playerScores[index])"
        }
        
        if let imgName = viewModel.highestScorePlayerImgPath, let fullPath = TLFileManager.shared.fullImagePath(from: imgName) {
            self.highestScorePlayerImgView.image = UIImage(contentsOfFile: fullPath)
        }
    }
}
