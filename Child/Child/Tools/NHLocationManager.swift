//
//  NHLocationManager.swift
//  Child
//
//  Created by Noah on 2018/2/28.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHLocationManager: NSObject {
    static let shareManager = NHLocationManager()
    fileprivate let mapManager = BMKMapManager()
    fileprivate let locManager: BMKLocationManager = {
        var manager = BMKLocationManager()
        //设置返回位置的坐标系类型
        manager.coordinateType = BMKLocationCoordinateType.BMK09LL;
        //设置距离过滤参数
        manager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        manager.activityType = CLActivityType.automotiveNavigation;
        //设置是否自动停止位置更新
        manager.pausesLocationUpdatesAutomatically = false;
        //设置是否允许后台定位
        manager.allowsBackgroundLocationUpdates = true;
        //设置位置获取超时时间
        manager.locationTimeout = 10;
        //设置获取地址信息超时时间
        manager.reGeocodeTimeout = 10;
        return manager
    }()
    class func prepareLocation() {
        if(CLLocationManager.authorizationStatus() == .denied) {
            NHAlertView.actionShow("提示", "定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许使用定位服务", [("立即设置",.default,{(action) in
                let url = URL.init(string: UIApplicationOpenSettingsURLString)
                if(UIApplication.shared.canOpenURL(url!)) {
                    UIApplication.shared.openURL(url!)
                }}),("取消",.default,{(action) in })])
        }
        let locationManager = NHLocationManager.shareManager
        let ret = locationManager.mapManager.start("oGNLogtyiZaf92Uxzm9W0ZXTzvYninqX", generalDelegate: locationManager)
        if ret == false {
            print("地图服务初始化失败")
        }
        BMKLocationAuth.sharedInstance().checkPermision(withKey: "oGNLogtyiZaf92Uxzm9W0ZXTzvYninqX", authDelegate: locationManager)
        locationManager.locManager.delegate = locationManager
    }

    func startlocation(_ finish:@escaping (BMKLocation?) -> ()) {
        self.locManager.requestLocation(withReGeocode: true, withNetworkState: true) { (location, netStatus, error) in
            finish(location)
        }
    }
}

extension NHLocationManager:BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate {
    func onGetPermissionState(_ error:integer_t) {
        print("onGetPermissionState:\(error)")
    }
    func onGetNetworkState(_ error:integer_t) {
        print("onGetNetworkState:\(error)")
    }
    func onCheckPermissionState(_ error:BMKLocationAuthErrorCode) {
        print("onCheckPermissionState:\(error.rawValue)")
    }
}

typealias AreaTuples = (name:String,code:String,parentCode:String)
class AreaManager {
    static let share:AreaManager = {
        let manager = AreaManager()
        let version = SyncVersion.query(tableName: NHTableName.V_AreaTable)
        if version == nil || (Int(version!.newVersion)! > Int(version!.nowVersion)!) {
            manager.getFromNet(version?.newVersion ?? "1")
        } else {
            var provinces:[AreaTuples] = [AreaTuples]()
            var citys:[AreaTuples] = [AreaTuples]()
            var districts:[AreaTuples] = [AreaTuples]()
            var areaValues = Database.shareDB.query(sql: "select * from \(NHTableName.V_AreaTable)")
            areaValues.forEach({ (areaDict) in
                if IsEquelString(areaDict["type"] as? String, "province") {
                    provinces.append((areaDict["name"] as! String,areaDict["code"] as! String,areaDict["parentCode"] as! String))
                } else if IsEquelString(areaDict["type"] as? String, "city") {
                    citys.append((areaDict["name"] as! String,areaDict["code"] as! String,areaDict["parentCode"] as! String))
                } else if IsEquelString(areaDict["type"] as? String, "town") {
                    districts.append((areaDict["name"] as! String,areaDict["code"] as! String,areaDict["parentCode"] as! String))
                }
            })
            manager.provinces = provinces
            manager.citys = citys
            manager.districts = districts
        }
        return manager
    }()
    var provinces:[AreaTuples]?
    var citys:[AreaTuples]?
    var districts:[AreaTuples]?
    
    func nowProvinceCode() -> String? {
        var nowCode = SystemPreferences().object(forKey: Constants.NOW_PROVINCE_CODE)
        if nowCode == nil {
            let provinces = Database.shareDB.query(sql: "select code from \(NHTableName.V_AreaTable) where type = 'province'")
            if UnEmptyArray(provinces) {
                nowCode = provinces[0]["code"] as! String
                SystemPreferences().set(nowCode, forKey: Constants.NOW_PROVINCE_CODE)
                return nowCode as? String
            } else {
                return nil
            }
        }
        return nowCode as? String
        //        let provinces = Database.shareDB.query(sql: "select * from \(NHTableName.V_AreaTable) where type = 'province' and code = '\(nowCode as! String)'")
        //        if UnEmptyArray(provinces) {
        //            let result = (provinces[0]["name"] as! String,provinces[0]["code"] as! String,"-1")
        //            return result
        //        } else {
        //            return nil
        //        }
    }
    
    func nowCitys() -> [AreaTuples]? {
        let provinceCode = nowProvinceCode()
        if provinceCode != nil {
            let citys = Database.shareDB.query(sql: "select * from \(NHTableName.V_AreaTable) where type = 'city' and parentCode = '\(provinceCode!)'")
            if UnEmptyArray(citys) {
                var nowCitys = [AreaTuples]()
                citys.forEach({ (city) in
                    nowCitys.append((city["name"] as! String,city["code"] as! String,city["parentCode"] as! String))
                })
                return nowCitys
            }
        }
        return nil
    }
    func nowTowns(cityCode:String) -> [AreaTuples]? {
        let towns = Database.shareDB.query(sql: "select * from \(NHTableName.V_AreaTable) where type = 'town' and parentCode = '\(cityCode)'")
        if UnEmptyArray(towns) {
            var nowTowns = [AreaTuples]()
            towns.forEach({ (town) in
                nowTowns.append((town["name"] as! String,town["code"] as! String,town["parentCode"] as! String))
            })
            return nowTowns
        }
        return nil
    }
    
    var insertSQL:String = {return "insert into \(NHTableName.V_AreaTable) (name,code,parentCode,type)"}()
    func getFromNet(_ newVersion:String) {
        Database.shareDB.delete(table: NHTableName.V_AreaTable)
        NHNet.share.GET(url: NHURL.LocURL(), isAlert:false) { (code, result) in
            if result != nil {
                DispatchQueue.global().async {
                    
                    let locInfo = result as? [[String: Any]]
                    var provinces:[AreaTuples] = [AreaTuples]()
                    var citys:[AreaTuples] = [AreaTuples]()
                    var districts:[AreaTuples] = [AreaTuples]()
                    locInfo?.forEach({ (provinceDict) in
                        if UnEmptyString(provinceDict["provinceName"]) && UnEmptyString(provinceDict["code"]) {
                            provinces.append((provinceDict["provinceName"] as! String,provinceDict["code"] as! String,"-1"))
                            Database.shareDB.insert(sql: self.insertSQL, args: [provinceDict["provinceName"] as! String,provinceDict["code"] as! String,"-1","province"])
                        }
                        let cityInfo = provinceDict["citys"] as? [[String: Any]]
                        cityInfo?.forEach({ (cityDict) in
                            if UnEmptyString(cityDict["cityName"]) && UnEmptyString(cityDict["cityCode"]) {
                                citys.append((cityDict["cityName"] as! String,cityDict["cityCode"] as! String,provinceDict["code"] as! String))
                                Database.shareDB.insert(sql: self.insertSQL, args: [cityDict["cityName"] as! String,cityDict["cityCode"] as! String,provinceDict["code"] as! String,"city"])
                            }
                            let districtInfo = cityDict["towns"] as? [[String: Any]]
                            districtInfo?.forEach({ (districtDict) in
                                if UnEmptyString(districtDict["townName"]) && UnEmptyString(districtDict["townCode"]) {
                                    districts.append((districtDict["townName"] as! String,districtDict["townCode"] as! String,cityDict["cityCode"] as! String))
                                    Database.shareDB.insert(sql: self.insertSQL, args: [districtDict["townName"] as! String,districtDict["townCode"] as! String,cityDict["cityCode"] as! String,"town"])
                                }
                            })
                        })
                    })
                    self.provinces = provinces
                    self.citys = citys
                    self.districts = districts
                    DispatchQueue.main.async {
                        print("更新地区表通知")
                        NotificationCenter.default.post(name: NHNotifyName.AreaUpdated, object: nil,userInfo: nil)
                        SyncVersion.insert(tableName: NHTableName.V_AreaTable, newVersion: newVersion)
                    }
                }
            }
        }
    }
}



