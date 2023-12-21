//
//  AppDataManager.swift
//  WebForm
//
//  Created by Lee on 9/1/2020.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class AppDataManager: NSObject {

    static let instance:AppDataManager = AppDataManager()
    
    private override init() {
        super.init()
    }
    
    //Call app init function when App open
    func initData() {
        DLog("initData")
    }

}
