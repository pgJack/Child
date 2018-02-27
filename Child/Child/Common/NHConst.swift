//
//  NHConst.swift
//  Child
//
//  Created by Noah on 2018/2/24.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

let kSCREEN_WIDTH = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? Double(UIScreen.main.bounds.size.height): Double(UIScreen.main.bounds.size.width)
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? Double(UIScreen.main.bounds.size.height): Double(UIScreen.main.bounds.size.width)
let IS_IPHONE_X = kSCREEN_HEIGHT == 812.0
let kNavigationH = IS_IPHONE_X ? 88 : 64
let kTabBarHeight = IS_IPHONE_X ? 83 : 49
let BottomHeight = IS_IPHONE_X ? 34 : 0

var getGUID = ProcessInfo.processInfo.globallyUniqueString

struct Constants {
    
}
