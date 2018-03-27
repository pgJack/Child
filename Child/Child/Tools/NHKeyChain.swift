//
//  NHKeyChain.swift
//  Child
//
//  Created by Noah on 2018/3/7.
//  Copyright © 2018年 NH. All rights reserved.
//

import Foundation

fileprivate let kKeychainAllInfo = "Noah.Smart.Child.com.allInfo"
fileprivate let kKeychainUDID = "Noah.Smart.Child.com.UDID"

struct KeyChain {
    
    fileprivate var AllInfoQuary : [String : Any] = [
        kSecClass as String : kSecClassGenericPassword,
        //服务
        kSecAttrService as String : kKeychainAllInfo,
        //账户名
        kSecAttrAccount as String : kKeychainAllInfo,
        
        kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
    ]
    fileprivate let UDID:String = (UIDevice.current.identifierForVendor?.uuidString)!
    
    func addUDID() -> String {
        let udid = UDID
        add(AllInfoQuary, [kKeychainUDID : udid])
        return udid
    }
    func queryUDID() -> String? {
        let allInfo = query(AllInfoQuary)
        var udid:String?
        if allInfo != nil && allInfo is [String: Any] {
            let allDict:Dictionary = allInfo as! [String: Any]
            if allDict[kKeychainUDID] is String {
                udid = allDict[kKeychainUDID] as? String
            }
        }
        return (udid != nil && udid!.isEmpty) ? udid : nil
    }
    
    func add(_ query: [String : Any], _ data: Any) {
        var addQuery: [String : Any] = query
        let delResult = SecItemDelete(addQuery as CFDictionary)
        print("keyChain delResult \(delResult)")
        //写入数据
        addQuery[kSecValueData as String] = NSKeyedArchiver.archivedData(withRootObject: data)
        let result = SecItemAdd(addQuery as CFDictionary, nil)
        if result != errSecSuccess {print("Err: \(kKeychainAllInfo) write to KC")}
    }
    
    func query(_ query: [String : Any]) -> Any?{
        var requestQuery: [String : Any] = query
        var udid:Any?
        
        requestQuery[kSecMatchLimit as String] = kSecMatchLimitOne
        requestQuery[kSecReturnData as String] = kCFBooleanTrue
        
        var requestResult : AnyObject?
        
        let err = withUnsafeMutablePointer(to: &requestResult) {
            SecItemCopyMatching(requestQuery as CFDictionary, UnsafeMutablePointer($0))
        }
        if err == errSecSuccess {
            let result = requestResult as! Data
            let currentString = String(data: result, encoding: .utf8)
            print("udid "+(currentString ?? ""))
            if let results = requestResult as? [String : Any] {
                let passdata = results[kSecValueData as String] as? Data
                udid = NSKeyedUnarchiver.unarchiveObject(with: passdata!)
            }
        }
        return udid
    }
    
    func delete() {
        SecItemDelete(AllInfoQuary as CFDictionary)
    }
}
