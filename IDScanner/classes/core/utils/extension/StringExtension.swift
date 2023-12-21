//
//  StringUtil.swift
//  NexChat
//
//  Created by Lee on 26/7/2018.
//  Copyright © 2018 Limited. All rights reserved.
//

import UIKit

extension String {
    func localized(arguments: [Any]? = nil) -> String {
        return NSLocalizedString(self, comment: "")
    }
}
