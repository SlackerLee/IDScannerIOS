//
//  FlowControlManager.swift
//  IDScanner
//
//  Created by iOS Team on 13/7/2021.
//

import Foundation
import UIKit
class FlowControlManager: NSObject {
    // Create a singleton instance
    static let instance: FlowControlManager = FlowControlManager()
    override init() {
        super.init()
    }
    func presentScannerDetailViewPage(_ vc: UIViewController,_ imageInfoList: [[String: Any]]?, resultImage: UIImage?) {
        if let scannerDetailTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScannerDetailTableViewController") as? ScannerDetailTableViewController {
            scannerDetailTableViewController.imageInfoList = imageInfoList
            scannerDetailTableViewController.resultImage = resultImage
            vc.navigationController?.pushViewController(scannerDetailTableViewController, animated: true)
        }
    }
}
