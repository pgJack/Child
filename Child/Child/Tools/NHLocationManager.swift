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

