//
//  PlayerFillInfoView.swift
//  TaLa
//
//  Created by huydoquang on 12/23/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

@objc protocol PlayerFillInfoViewDelegate: class {
    func playerFillInfoViewDidTap(playerFillInfoView: PlayerFillInfoView)
    func playerFillInfoDidChooseImage(from sourceType: UIImagePickerControllerSourceType, with playerFillInfoView: PlayerFillInfoView)
    func playerFillInfoDidSave(image: UIImage?, name: String?)
    func playerFillInfoDidCancel()
}


class PlayerFillInfoView: UIView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberPlayerLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageAlertView: UIView!
    @IBOutlet weak var contentViewAlignCenterY: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private weak var delegate: (PlayerFillInfoViewDelegate & UIViewController)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.addObserver()
    }
    
    init(frame: CGRect, delegate: PlayerFillInfoViewDelegate & UIViewController, player: Player?) {
        super.init(frame: frame)
        self.setupFromXib()
        self.delegate = delegate
        self.updateUI(with: player)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupFromXib()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.willShowKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willHideKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.backgroundColor
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        
        self.imageAlertView.layer.cornerRadius = 7.0
        self.imageAlertView.layer.masksToBounds = true
    }
    
    private func updateUI(with player: Player?) {
        guard let player = player else { return }
        self.numberPlayerLabel.text = String.playerNumber(with: Int(player.id))
        self.nameTextField.text = player.name
        if let imageName = player.image, let fullPath = TLFileManager.shared.fullImagePath(from: imageName) {
            self.avatarImageView.image = UIImage(contentsOfFile: fullPath)
        }
    }
    
    private func showImageAlertView() {
        UIView.transition(from: self.contentView, to: self.imageAlertView, duration: 0.25, options: .showHideTransitionViews)
    }
    
    private func showContentView() {
        UIView.transition(from: self.imageAlertView, to: self.contentView, duration: 0.25, options: .showHideTransitionViews)
    }
    
    func didChooseImage(image: UIImage?) {
        self.avatarImageView.image = image
        self.showContentView()
    }
    
    @objc func willShowKeyboard(notification: Notification) {
        let dict: NSDictionary = notification.userInfo! as NSDictionary
        let value = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardHeight = value.cgRectValue.size.height
        
        let margin: CGFloat = 20.0
        let contentViewBottomSpace = self.bounds.height - self.contentView.frame.maxY - margin
        guard contentViewBottomSpace < keyboardHeight else { return }
        self.contentViewAlignCenterY.constant -= keyboardHeight - contentViewBottomSpace
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    @objc func willHideKeyboard(notification: Notification) {
        self.contentViewAlignCenterY.constant = 0.0
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    @IBAction func dismiss(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
        self.removeFromSuperview()
        self.delegate?.playerFillInfoViewDidTap(playerFillInfoView: self)
    }
    
    @IBAction func addImage(_ sender: UITapGestureRecognizer) {
        self.showImageAlertView()
    }
    
    @IBAction func endEditingNameTextField(_ sender: UITapGestureRecognizer) {
        self.nameTextField.resignFirstResponder()
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.delegate?.playerFillInfoDidSave(image: self.avatarImageView.image, name: self.nameTextField.text)
        self.removeFromSuperview()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.removeFromSuperview()
        self.delegate?.playerFillInfoDidCancel()
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let sourceType: UIImagePickerControllerSourceType = sender.tag == ImageSourceType.library.rawValue ? .photoLibrary : .camera
        self.delegate?.playerFillInfoDidChooseImage(from: sourceType, with: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
