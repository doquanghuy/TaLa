//
//  BaseViewController.swift
//  TaLa
//
//  Created by huydoquang on 2/4/18.
//  Copyright © 2018 huydoquang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class var name: String {
        return String(describing: self)
    }
    
    func comeToRoot() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let navVC = appDelegate?.window?.rootViewController as? UINavigationController
        navVC?.dismiss(animated: true, completion: {
            navVC?.viewControllers = [PlayerViewController.instance]
        })
    }
}
