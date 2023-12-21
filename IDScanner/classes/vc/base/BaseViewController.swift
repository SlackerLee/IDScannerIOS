//
//  BaseViewController.swift
//  WebForm
//
//  Created by Lee on 7/1/2020.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {
    
    func showToast(message: String) {
        self.view.makeToast(message)
    }

}
