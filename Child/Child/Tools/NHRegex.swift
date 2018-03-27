//
//  NHRegex.swift
//  Child
//
//  Created by Noah on 2018/3/8.
//  Copyright © 2018年 NH. All rights reserved.
//

import Foundation

func IsPhoneNumber(_ num:String?) -> Bool {
    if num == nil || num!.isEmpty {return false}
    return regex(pattern: "^\\d{11}$", str: num!)
}
func IsEmptyString(_ string:String?) -> Bool {
    if string == nil || string!.isEmpty {return true} else {return false}
}
func UnEmptyString(_ string:Any?) -> Bool {
    if string != nil && string is String && !((string as! String).isEmpty) {return true} else {return false}
}
func IsEquelString(_ stringA:String?, _ stringB:String?) -> Bool {
    if stringA == nil || stringB == nil {return false} else {
        if stringA! == stringB! {
            return true
        } else {
            return false
        }
    }
}
func UnEmptyArray(_ array:Any?) -> Bool {
    if array != nil && array is [Any] && (array as! [Any]).count > 0 {return true} else {return false}
}
func regex(pattern:String, str:String) -> Bool {
    let regex = try! NSRegularExpression(pattern: pattern, options:[NSRegularExpression.Options.caseInsensitive])
    let resultNum = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0) , range: NSMakeRange(0, str.count))
    if resultNum>=1 {
        return true
    }
    return false
}
