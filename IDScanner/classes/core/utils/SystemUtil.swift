//
//  SystemUtil.swift
//  IDScanner
//
//  Created by iOS Team on 13/7/2021.
//

import UIKit

class SystemUtil {
    /*
     Function for get the top presenting view controller
     */
    static func getTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return getTopViewController(controller: navigationController.visibleViewController)
        }
        if let tabBarController = controller as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return getTopViewController(controller: selectedViewController)
            }
        }
        if let presentedViewController = controller?.presentedViewController {
            return getTopViewController(controller: presentedViewController)
        }
        return controller
    }
}
