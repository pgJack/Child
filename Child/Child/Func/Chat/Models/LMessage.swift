//
//  LMessage.swift
//  Child
//
//  Created by Noah on 2018/3/23.
//  Copyright © 2018年 NH. All rights reserved.
//

import Foundation

enum LMessageType {
    case Word
    case Voice
    case Picture
    case Web
    case Native
}

struct LMessage {
    var type:LMessageType = LMessageType.Word
    var data:Data!
    var date:Date!
}
