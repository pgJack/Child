//
//  NHChat.swift
//  Child
//
//  Created by Noah on 2018/3/27.
//  Copyright © 2018年 NH. All rights reserved.
//

import Foundation


class NHChat: NSObject {
    var unreadnum = 0
    var userid:String?
    var username:String?
    var usericon:String?
    var lastmessage:LMessage?
    var messages:[LMessage]?
}
