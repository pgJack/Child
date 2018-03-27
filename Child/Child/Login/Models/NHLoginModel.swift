//
//  NHLoginModel.swift
//  Child
//
//  Created by Noah on 2018/3/8.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHLoginModel: NSObject {

    var placeHolder:String?
    var value:String?
    var isSendCode:Bool = false
    var keyboardType: UIKeyboardType = UIKeyboardType.default
    
    init(_ placeHolder:String!, _ value:String!, _ isSendCode:Bool = false, _ keyboardType:UIKeyboardType = UIKeyboardType.default) {
        self.placeHolder = placeHolder
        self.value = value
        self.keyboardType = keyboardType
        self.isSendCode = isSendCode
    }
    
}
