//
//  ConstantURL.swift
//  IDScanner
//
//  Created by Lee on 25/6/2021.
//

import UIKit

class ConstantURL: NSObject {

    static func isPro() -> Bool {
        #if DEBUG
            return false
        #else
            return true
        #endif
    }

    static let DOMAIN_PRO = "http://" + HOSTNAME_PRO + "/"
    static let DOMAIN_DEV = "http://" + HOSTNAME_DEV + "/"

    // TODO
    static let HOSTNAME_PRO = ""
    static let HOSTNAME_DEV = ""

    static let URL_ID_SCAN = ""

}

