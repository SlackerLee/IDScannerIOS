//
//  Logger.swift
//  WebForm
//
//  Created by Lee on 7/1/2020.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

func DLog(_ message: String, function: String = #function, file: String = #file, line: Int = #line, column: Int = #column) {
    let msgStr = String(describing: message)
    let funStr = String(describing: function)
    let fileStr = (file as NSString).lastPathComponent
    let lineStr = String(describing: line)
    #if DEBUG
    print("[\(function)][\(fileStr):\(lineStr)] - \(message)")
    #endif
}

class Logger: NSObject {

}
