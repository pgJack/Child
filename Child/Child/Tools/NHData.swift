//
//  NHData.swift
//  Child
//
//  Created by Noah on 2018/3/2.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHData: NSObject {
    static let share = NHData()
    var token:String?
    
    
}

class NHUser: NSObject {
    static let share = NHUser()
    
    @objc var imgid: String?
    @objc var lastDeviceId: String?
    @objc var lastSignIp: String?
    @objc var lastSignTime: String?
    @objc var tenantid:NSNumber?
    
    private var _userId:String?
    @objc var userId:String? {
        set {
            _userId = newValue
            if _userId != nil {
                SystemPreferences().set(_userId, forKey: Constants.USER_ID)
            }
        } get {
            if _userId == nil{
                _userId = SystemPreferences().string(forKey: Constants.USER_ID)
            }
            return _userId
        }
    }
    private var _name: String?
    @objc var name: String? {
        set {
            _name = newValue
            if _name != nil {
                SystemPreferences().set(_name, forKey: Constants.USER_NAME)
            }
        } get {
            if _name == nil{
                _name = SystemPreferences().string(forKey: Constants.USER_NAME)
            }
            return _name
        }
    }

    
    private var _phone:String?
    @objc var phone:String? {
        set {
            _phone = newValue
            if _phone != nil {
                SystemPreferences().set(_phone, forKey: Constants.USER_PHONE)
            }
        } get {
            if _phone == nil{
                _phone = SystemPreferences().string(forKey: Constants.USER_PHONE)
            }
            return _phone
        }
    }
    
    class func Logined() -> Bool {
        if !IsEmptyString(SystemPreferences().string(forKey:Constants.USER_ID)) {
            return true
        } else {
            return false
        }
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        super.setValuesForKeys(keyedValues)
        
        print("SET \(self) INTO  \(type(of: self)) ")
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
