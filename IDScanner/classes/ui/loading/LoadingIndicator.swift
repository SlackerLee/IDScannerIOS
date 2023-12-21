//
//  NavActivityIndicator.swift
//  NexChat
//
//  Created by iOS Team on 4/3/2021.
//  Copyright © 2021 Limited. All rights reserved.
//

import Foundation
import UIKit

class LoadingIndicator {
    static let instance: LoadingIndicator = LoadingIndicator()

    let activityLabel = UILabel(frame: CGRect(x: 24, y: 0, width: 0, height: 0))
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let activityView = UIView()
 
    func startAnimating(title: String, textColor: UIColor? = UIColor.black, style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.gray, view: UIView) {
     
        activityIndicator.style = style
        activityIndicator.color = .white
        activityLabel.text = title
        activityLabel.textColor = textColor
        activityLabel.sizeToFit()
        
        let xPoint = view.frame.midX
        let yPoint = view.accessibilityFrame.midY
        let widthForActivityView = activityLabel.frame.width - (activityIndicator.frame.width/2)
        
        activityView.frame = CGRect(x: xPoint, y: yPoint, width: widthForActivityView, height: view.frame.height)
        activityLabel.center.y = activityView.center.y
        activityIndicator.center.y = activityView.center.y
     
        activityView.addSubview(activityIndicator)
        activityView.addSubview(activityLabel)
        
        view.addSubview(activityView)
        activityIndicator.startAnimating()
    }
  
    func stopAnimating(navigationItem: UINavigationItem) {
        activityIndicator.stopAnimating()
        activityView.removeFromSuperview()    }
}
