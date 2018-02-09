//
//  Ext+UIViewController.swift
//  TaLa
//
//  Created by huydoquang on 2/6/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

extension UIViewController {
    static var rootNavigationController: UINavigationController? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? UINavigationController
    }
}
