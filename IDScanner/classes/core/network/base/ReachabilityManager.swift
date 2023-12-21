//
//  ReachabilityManager.swift
//  WebForm
//
//  Created by Lee on 7/1/2020.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Foundation
import Reachability

class ReachabilityManager: NSObject {
    var reachability: Reachability?

    // Create a singleton instance
    static let instance: ReachabilityManager = ReachabilityManager()
    private var isNoNetwork:Bool = true

    override init() {
        super.init()

        // Initialise reachability
        do {
            reachability = try Reachability()
        } catch {
            print(error.localizedDescription)
        }

        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )

        do {
            // Start the network status notifier
            try reachability?.startNotifier()
        } catch {
            DLog("Unable to start network status change notifier")
        }

    }

    @objc func networkStatusChanged(_ notification: Notification) {
        DLog("networkStatusChanged")
        let reachability = notification.object as! Reachability // swiftlint:disable:this force_cast
        switch reachability.connection {
        case .wifi:
            DLog("Reachable via WiFi")
            if (self.isNoNetwork) {
                self.isNoNetwork = false
            }
            //QueueTaskUtil.instance.fireAllSubmissionToQueue()
        case .cellular:
            DLog("Reachable via Cellular")
            if (self.isNoNetwork) {
                self.isNoNetwork = false
            }
            //QueueTaskUtil.instance.fireAllSubmissionToQueue()
        case .none:
            self.isNoNetwork = true
            DLog("Network not reachable")
            //QueueTaskUtil.instance.fireAllSubmissionToQueue()
        default :
            self.isNoNetwork = true
            DLog("Network not reachable")
            //QueueTaskUtil.instance.fireAllSubmissionToQueue()
        }
    }

    func stopNotifier() {
        do {
            // Stop the network status notifier
            try (ReachabilityManager.instance.reachability)?.startNotifier()
        } catch {
            DLog("Error stopping notifier")
        }
    }

    func isReachable() -> Bool {
        if let connection = (ReachabilityManager.instance.reachability)?.connection,
            (connection == .cellular || connection == .wifi){
            return true
        } else {
            return false
        }
    }
}
