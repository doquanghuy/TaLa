
//
//  PlayerViewController.swift
//  TaLa
//
//  Created by huydoquang on 12/23/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    @IBOutlet weak var playersViewContainer: UIView!
    private var playerFillInfoView: PlayerFillInfoView?
    private var playersView: PlayersView?
    private var currentEditPlayerNumber: Int!
    private var playerViewModel: SetUpPlayer = SetUpPlayerViewModel()
    private var didShowPlayerFillInfoView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    private func setupUI() {
        self.playersView = PlayersView.addView(to: playersViewContainer, with: playersViewContainer.bounds, delegate: self)
    }
    
    private func setupData() {
        playerViewModel.setupData()
    }
    
    @IBAction func back(_ sender: Any) {
        self.playerViewModel.cancel()
    }
    
    @IBAction func save(_ sender: Any) {
        self.playerViewModel.save()
        self.performSegue(withIdentifier: Constants.Segues.fromPlayerVCToRuleVC, sender: nil)
    }
}

extension PlayerViewController: PlayersViewDelegate {
    func playerViewChangingPosition(playerView: UIImageView, bounderView: BounderView) {
        //TODO
    }
    
    func playerViewDidEndChangePosition(from fromPlayerView: UIImageView, to toPlayerView: UIImageView, from fromBounderView: BounderView, to toBounderView: BounderView) {
        self.playersView?.swapPlayerViewLocation(from: fromPlayerView, to: toPlayerView, from: fromBounderView, to: toBounderView)
        self.playerViewModel.swapPlayer(fromIndex: fromBounderView.tag, toIndex: toBounderView.tag)
    }
    
    func playerViewDidBeginChangePosition(playerView: UIImageView, bounderView: BounderView) {
        //TODO
    }
    
    func playerViewDidTap(playerView: UIImageView, playerNumber: Int) {
        guard !self.didShowPlayerFillInfoView else { return }
        self.didShowPlayerFillInfoView = true
        self.currentEditPlayerNumber = playerNumber
        self.playerFillInfoView = PlayerFillInfoView.addView(to: self.view, with: self.view.bounds, delegate: self, player: self.playerViewModel.player(at: playerNumber))
    }
}

extension PlayerViewController: PlayerFillInfoViewDelegate {
    func playerFillInfoViewDidTap(playerFillInfoView: PlayerFillInfoView) {
        self.didShowPlayerFillInfoView = false
    }
    
    func playerFillInfoDidChooseImage(from sourceType: UIImagePickerControllerSourceType, with playerFillInfoView: PlayerFillInfoView) {
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) || sourceType != .camera else { return }
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        imgPicker.sourceType = sourceType
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func playerFillInfoDidSave(image: UIImage?, name: String?) {
        self.playerViewModel.setupPlayerInfo(withImage: image, andName: name, andScore: 0, at: self.currentEditPlayerNumber)
        self.playersView?.updateUI(image: image, name: name, playerNumber: self.currentEditPlayerNumber)
        self.didShowPlayerFillInfoView = false
    }
    
    func playerFillInfoDidCancel() {
        self.didShowPlayerFillInfoView = false
    }
}

extension PlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image: UIImage!
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = originalImage
        }
        self.playerFillInfoView?.didChooseImage(image: image)
        self.dismiss(animated: true, completion: nil)
    }
}
