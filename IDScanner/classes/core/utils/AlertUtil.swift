//
//  AlertUtil.swift
//  IDScanner
//
//  Created by iOS Team on 13/7/2021.
//

import Foundation
import UIKit

class AlertUtil {
    /**
     This method uses to prepare an alert dialog
     @errCode   : error code of the message
     @actions   : action of button(s) display in the popup dialog
     */
    static func alert(_ title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
        return alert(title, message: message, actions: actions, preferredStyle: .alert)
    }
    static func alert(_ title: String?, message: String?, actions: [UIAlertAction], preferredStyle:UIAlertController.Style) -> UIAlertController {
        return alert(title, message: message, actions: actions, preferredStyle: preferredStyle, sourceView: nil)
    }
    static func alert(_ title: String?, message: String?, actions: [UIAlertAction], preferredStyle:UIAlertController.Style, sourceView: UIView?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            alert.addAction(action)
        }
        if(preferredStyle == .actionSheet) {
            addActionSheetIpadSupport(alert: alert, sourceView: sourceView)
        }
        return alert
    }
    private static func addActionSheetIpadSupport(alert: UIAlertController, sourceView: UIView? = nil) {
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            alert.modalPresentationStyle = .popover
            if let presenter = alert.popoverPresentationController {
                if let viewRect = sourceView {
                    presenter.sourceView = viewRect
                    presenter.sourceRect = viewRect.bounds
                    presenter.permittedArrowDirections = .any
                } else {
                    guard let viewRect = SystemUtil.getTopViewController()?.view else {
                        return
                    }
                    presenter.sourceView = viewRect
                    presenter.sourceRect = CGRect(x: viewRect.bounds.midX, y: viewRect.bounds.midY, width: 0, height: 0)
                    presenter.permittedArrowDirections = []
                }
            }
        }
    }

    static func present(alert: UIAlertController, animated: Bool, completion: (() -> Void)? = nil) {
        if let vc = SystemUtil.getTopViewController() {
            if !vc.isKind(of: UIAlertController.self) {
                if (!vc.isBeingDismissed) {
                    vc.present(alert, animated: animated, completion: completion)
                } else {
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: animated, completion: completion)
                }
            }
        }
    }
    static func showConfirmAlert(_ title: String?, message: String?, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = AlertUtil.alert(title, message:message ,actions:
            [AlertUtil.actOK(btnCode: "confirm", style: .default, completionHandler: completionHandler)])
        DispatchQueue.main.async {
            AlertUtil.present(alert: alert, animated: true, completion: nil)
        }
    }
    
    
    // ==================================================
    //  Default action of alert controller
    // ==================================================
    static func actOK(btnCode: String = "OK", style: UIAlertAction.Style = .default, completionHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: btnCode, style: style, handler: completionHandler)
        /*Auto-test*/
        action.accessibilityLabel = "button1"
        /*Auto-test*/
        return action
    }
}
