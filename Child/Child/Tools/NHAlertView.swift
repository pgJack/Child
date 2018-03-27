//
//  NHAlertView.swift
//  Child
//
//  Created by Noah on 2018/2/28.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHAlertView: NSObject {

    class func noticeShow(_ message:String) {
        simpleShow("提示", message, "确定")
    }
    
    class func simpleShow(_ title:String,_ message:String,_ buttonName:String) {
        
        actionShow(title, message, [(title: buttonName, style: .cancel, { (action) in
            })])
        
    }
    class func actionShow(_ title:String, _ message:String, _ actions:[(String, UIAlertActionStyle,((UIAlertAction) -> Swift.Void)?)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach {
            let tempAction = UIAlertAction(title: $0.0, style: $0.1, handler: $0.2)
            alert.addAction(tempAction)
        }
        AppDelegate.nowShowController().present(alert, animated: true, completion: nil)
    }
}
