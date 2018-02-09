//
//  Ext+UIImageView.swift
//  TaLa
//
//  Created by huydoquang on 1/15/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

extension UIImageView {
    func temp(on container: UIView) -> UIImageView {
        let frame = container.convert(self.frame, from: self.superview)
        let temp = UIImageView(frame: frame)
        temp.backgroundColor = self.backgroundColor
        temp.image = self.image
        temp.layer.cornerRadius = self.layer.cornerRadius
        temp.layer.masksToBounds = self.layer.masksToBounds
        container.addSubview(temp)
        return temp
    }
    
    static func swapInfo(firstImgView: UIImageView, with secondImgView: UIImageView) {
        let firstImage = firstImgView.image
        let firstBackgroundColor = firstImgView.backgroundColor
        let firstCornerRadius = firstImgView.layer.cornerRadius
        let firstMaskToBounds = firstImgView.layer.masksToBounds

        let secondImage = secondImgView.image
        let secondBackgroundColor = secondImgView.backgroundColor
        let secondCornerRadius = secondImgView.layer.cornerRadius
        let secondMaskToBounds = secondImgView.layer.masksToBounds
        
        firstImgView.image = secondImage
        firstImgView.backgroundColor = secondBackgroundColor
        firstImgView.layer.cornerRadius = secondCornerRadius
        firstImgView.layer.masksToBounds = secondMaskToBounds
        
        secondImgView.image = firstImage
        secondImgView.backgroundColor = firstBackgroundColor
        secondImgView.layer.cornerRadius = firstCornerRadius
        secondImgView.layer.masksToBounds = firstMaskToBounds
    }
    
    func getInfo(from secondImgView: UIImageView) {
        self.image = secondImgView.image
        self.backgroundColor = secondImgView.backgroundColor
        self.layer.cornerRadius = secondImgView.layer.cornerRadius
        self.layer.masksToBounds = secondImgView.layer.masksToBounds
    }
    
    func changeImage(to image: UIImage?, duration: Double = 0.25, completion: (() -> Void)? = nil) {
        self.layer.contents = image?.cgImage
        let contentAnim = CustomCABasicAnimation.animation(keyPath: "contents") { (finished, anim) in
            self.image = image
            completion?()
        }
        contentAnim.fromValue = self.image?.cgImage
        contentAnim.duration = duration
        self.layer.add(contentAnim, forKey: nil)
    }
}
