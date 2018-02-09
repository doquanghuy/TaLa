
//
//  PlayerViewController.swift
//  TaLa
//
//  Created by huydoquang on 12/23/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

class PlayerViewController: BaseViewController {
    @IBOutlet weak var playersView: PlayersView!
    private var playerFillInfoView: PlayerFillInfoView?
    private var currentEditPlayerNumber: Int!
    private var didShowPlayerFillInfoView = false
    private var isEdit = false
    var playerViewModel: SetUpPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class var instance: PlayerViewController {
        return UIStoryboard(name: Constants.Storyboards.main.name, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboards.main.viewControllers[self.name]!) as! PlayerViewController
        
    }
    
    func enableBarButtonItems() {
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func unableBarButtonItems() {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension PlayerViewController: PlayersViewDelegate {
    func playerViewChangingPosition(playerView: UIImageView, bounderView: BounderView) {
        //TODO
    }
    
    func playerViewDidEndChangePosition(from fromPlayerView: UIImageView, to toPlayerView: UIImageView, from fromBounderView: BounderView, to toBounderView: BounderView) {
        self.playerViewModel.swapPlayer(fromIndex: fromBounderView.tag, toIndex: toBounderView.tag)
    }
    
    func playerViewDidBeginChangePosition(playerView: UIImageView, bounderView: BounderView) {
        //TODO
    }
    
    func playerViewDidTap(playerView: UIImageView, playerNumber: Int) {
        guard !self.didShowPlayerFillInfoView else { return }
        self.unableBarButtonItems()
        self.didShowPlayerFillInfoView = true
        self.currentEditPlayerNumber = playerNumber
        self.playerFillInfoView = PlayerFillInfoView(frame: self.view.bounds, delegate: self, player: self.playerViewModel.player(at: playerNumber))
        self.view.addSubview(self.playerFillInfoView!)
        self.playerFillInfoView?.contentView?.transform = CGAffineTransform.identity.scaledBy(x: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 0.25, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.playerFillInfoView?.contentView?.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }) { (finished) in
            self.playerFillInfoView?.contentView?.transform = CGAffineTransform.identity
        }
    }
}

extension PlayerViewController: PlayerFillInfoViewDelegate {
    func playerFillInfoViewDidTap(playerFillInfoView: PlayerFillInfoView) {
        self.didShowPlayerFillInfoView = false
        self.enableBarButtonItems()
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
        self.enableBarButtonItems()
    }
    
    func playerFillInfoDidCancel() {
        self.didShowPlayerFillInfoView = false
        self.enableBarButtonItems()
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
