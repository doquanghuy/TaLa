//
//  EditPlayerViewController.swift
//  TaLa
//
//  Created by huydoquang on 2/5/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

protocol EditPlayerViewControllerDelegate: class {
    func dismissViewController(animated: Bool, completion: (() -> Void)?)
    func didSaveEditRule(animated: Bool, completion: (() -> Void)?)
}

class EditPlayerViewController: PlayerViewController {
    weak var delegate: EditPlayerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
    }

    private func setupUI() {
        self.navigationItem.rightBarButtonItem?.title = "Save"
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
    }
    
    
    private func setupData() {
        self.playerViewModel = SetUpPlayerViewModel(forceCreate: false)
    }
    
    @IBAction func back(_ sender: Any) {
        self.playerViewModel.cancel()
        self.delegate?.dismissViewController(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        self.playerViewModel.save()
        self.delegate?.didSaveEditRule(animated: true, completion: nil)
    }
}
