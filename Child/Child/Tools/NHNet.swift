//
//  NHNet.swift
//  Child
//
//  Created by Noah on 2018/2/28.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit
import Alamofire

class NHNet: NSObject {
    
    static let share = NHNet()
    fileprivate let manager:SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15
        let session = SessionManager.init(configuration: configuration)
        return session
    }()
    var netPool:Dictionary = [String: DataRequest]()
    
    func GET(
        url:String = "http://apis.map.qq.com/ws/district/v1/list?key=K3VBZ-M6WWV-PPSPY-UVGGC-DRM2Z-PGBMV",
        parameters: [String: Any],
        _ finished: @escaping (_ code: Int, _ data: Any?) -> Void
        ) {
        let uuid:String = GetGUID()
        let dataRequest:DataRequest = manager.request(url, parameters: parameters, encoding: URLEncoding(destination: .methodDependent)).responseJSON(completionHandler: { (resultJSON) in
            let json = resultJSON.result.value
            if json != nil {
                let resultObject = JSON.init(json!).dictionary
                if resultObject != nil {
                    let code:Int = resultObject!["status"]?.int ?? 1
                    let data:Any? = resultObject!["result"]?.rawValue
                    finished(code,data)
                }
            }
            self.netPool[uuid] = nil
        })
        
        netPool[uuid] = dataRequest
    }
    
    func POST(
        url:String = NHURL.baseURL(),
        code: NSString,
        params: Dictionary<String, Any>,
        _ finished: @escaping (_ code: Int, _ data: Any?) -> Void
        ) {
        
        let param = [
            "code": "GET_QUERY_DATA"
            
        ]
        let json = JSON.init(param).rawString()

        let parameters:Parameters = [
            "token": NHData.share.token ?? "",
            "service": "moblie",
            "code": code,
            "data": json ?? "",
            "version": NHAPP.appVersion,
            "mobile": "",
            "userid": "",
            "tenantid": "",
            "deviceid": GetUDID
        ]
        let uuid:String = GetGUID()
        let dataRequest:DataRequest = manager.request(url, method: .post, parameters: parameters, encoding:  URLEncoding.httpBody).responseJSON(completionHandler: { (resultJSON) in
            let json = resultJSON.result.value
            if json != nil {
                let resultObject = JSON.init(json!).dictionary
                if resultObject != nil {
                    let code:Int = resultObject!["status"]?.int ?? 1
                    let data:Any? = resultObject!["result"]?.rawValue
                    finished(code,data)
                }
            }
            self.netPool[uuid] = nil
        })
        netPool[uuid] = dataRequest
    }
    
}

class NHURL: NSObject {
    class func baseURL() -> String {
        return firstLevelURL() + secondLevelURL() + thirdLevelURL()
    }
    private class func firstLevelURL() -> String {
        return "http://121.199.44.59:8088"
    }
    private class func secondLevelURL() -> String {
        return "/yypt/"
    }
    private class func thirdLevelURL() -> String {
        return "service.mobi"
    }
}
