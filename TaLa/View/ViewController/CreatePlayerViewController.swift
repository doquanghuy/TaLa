//
//  CreatePlayerViewController.swift
//  TaLa
//
//  Created by huydoquang on 2/6/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class CreatePlayerViewController: PlayerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    private func setupUI() {
        self.navigationItem.rightBarButtonItem?.title = "Save"
        self.navigationItem.leftBarButtonItem = nil
    }

    private func setupData() {
        self.playerViewModel = SetUpPlayerViewModel(forceCreate: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.playerViewModel.cancel()
    }
    
    @IBAction func save(_ sender: Any) {
        self.playerViewModel.save()
        self.performSegue(withIdentifier: Constants.Segues.fromPlayerVCToRuleVC, sender: nil)
    }
}
