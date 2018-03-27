//
//  NHNet.swift
//  Child
//
//  Created by Noah on 2018/2/28.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit
import Alamofire

let NetErrorCode = 404

class NHNet: NSObject {
    
    static let share:NHNet = {
        var net = NHNet()
        return net
    }()
    
    
    fileprivate let manager:SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15
        let session = SessionManager.init(configuration: configuration)
        
        return session
    }()
    var netPool:Dictionary = [String: DataRequest]()
    
    func GET(
        url:String = "",
        _ parameters: [String: Any]? = nil,
        isAlert: Bool = true,
        _ finished: @escaping (_ code: Int, _ data: Any?) -> Void
        ) {
        let uuid:String = GetGUID()
        let dataRequest:DataRequest = manager.request(url, parameters: parameters, encoding: URLEncoding(destination: .methodDependent)).responseJSON(completionHandler: { (resultJSON) in
            var result = resultJSON.result.value as? Dictionary<String, Any>
            if result != nil {
                let code:String? = result!["code"] as? String
                let data:Any? = result!["data"]
                let message:String? = result!["message"] as? String
                if code != "200" && isAlert {
                    NHAlertView.noticeShow(message ?? "网络异常, 请检查网络后重试")
                    finished(Int(code!) ?? 1,nil)
                } else {
                    finished(Int(code!)!,data)
                }
            } else {
                finished(NetErrorCode,nil)
                if isAlert {NHAlertView.noticeShow("网络异常, 请检查网络后重试")}
            }
            self.netPool[uuid] = nil
        })
        
        netPool[uuid] = dataRequest
    }
    
    func POST(
        url:String,
        code: String,
        params: Dictionary<String, Any>?,
        isAlert: Bool = true,
        _ finished: @escaping (_ code: Int, _ data: Any?) -> Void
        ) {
        
        let json = (params != nil) ? JSON.init(params!).rawString() : ""
        
        let parameters:Parameters = [
            "token": NHData.share.token ?? "",
            "service": "moblie",
            "code": code,
            "data": json ?? "",
            "version": NHAPP.appVersion,
            "mobile": NHUser.share.phone ?? "",
            "userid": NHUser.share.userId ?? "",
            "tenantid": NHUser.share.tenantid ?? "",
            "deviceid": GetUDID
        ]
        let uuid:String = GetGUID()
        let dataRequest:DataRequest = manager.request(url, method: .post, parameters: parameters, encoding:  URLEncoding.httpBody).responseJSON(completionHandler: { (resultJSON) in
            var result = resultJSON.result.value as? Dictionary<String, Any>
            print("URL:\(url)\nParams:\(parameters)\nreturn\(result ?? ["null":"null"])")
            if result != nil {
                let code:String? = result!["code"] as? String
                let data:Any? = result!["data"]
                let message:String? = result!["message"] as? String
                if code != "200" && isAlert {
                    NHAlertView.noticeShow(message ?? "网络异常, 请检查网络后重试")
                    finished(Int(code!) ?? 1,nil)
                } else {
                    finished(Int(code!)!,data)
                }
            } else {
                finished(NetErrorCode,nil)
                if isAlert {NHAlertView.noticeShow("网络异常, 请检查网络后重试")}
            }
            self.netPool[uuid] = nil
        })
        netPool[uuid] = dataRequest
    }
    
}

struct NHSignCode {
    var IN = "1"
    var UP = "2"
    var OUT = "3"
}

class NHURL: NSObject {

    class func LoginURL() -> String {
        return baseURL() + basePath() + loginLevel()
    }
    class func LocURL() -> String {
        return baseURL() + basePath() + locationLevel()
    }
    private class func baseURL() -> String {
        return "http://13.125.234.135:8080"
    }
    private class func basePath() -> String {
        return "/base_platform/"
    }
    private class func loginLevel() -> String {
        return "user/service"
    }
    private class func locationLevel() -> String {
        return "province/getPro"
    }
}
