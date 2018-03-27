//
//  NHConst.swift
//  Child
//
//  Created by Noah on 2018/2/24.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

//页面
let kSCREEN_WIDTH = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? CGFloat(UIScreen.main.bounds.size.height): CGFloat(UIScreen.main.bounds.size.width)
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? CGFloat(UIScreen.main.bounds.size.height): CGFloat(UIScreen.main.bounds.size.width)
let IS_IPHONE_X = kSCREEN_HEIGHT == 812.0
let kNavigationH = CGFloat(IS_IPHONE_X ? 88.0 : 64.0)
let kTabBarHeight = CGFloat(IS_IPHONE_X ? 83.0 : 49.0)
let BottomHeight = CGFloat(IS_IPHONE_X ? 34.0 : 0.0)

//APP信息
struct NHAPP {
    static let appDisplayName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String  //程序名称
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String //主程序版本号
    static let buildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String //版本号（内部标示）
}
struct NHDevice {
    //设备信息
    static let iosVersion: String = UIDevice.current.systemVersion //ios版本
    static let systemName: String = UIDevice.current.systemName //设备名称
    static let devicePlatform: String = {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        var platform:String = String(cString: machine)
        if (platform == "iPhone1,1") {return "iPhone 2G (A1203)"};
        if (platform == "iPhone1,2"){return "iPhone 3G (A1241/A1324)"};
        if (platform == "iPhone2,1"){return "iPhone 3GS (A1303/A1325)"};
        if (platform == "iPhone3,1"){return "iPhone 4 (A1332)"};
        if (platform == "iPhone3,2"){return "iPhone 4 (A1332)"};
        if (platform == "iPhone3,3"){return "iPhone 4 (A1349)"};
        if (platform == "iPhone4,1"){return "iPhone 4S (A1387/A1431)"};
        if (platform == "iPhone5,1"){return "iPhone 5 (A1428)"};
        if (platform == "iPhone5,2"){return "iPhone 5 (A1429/A1442)"};
        if (platform == "iPhone5,3"){return "iPhone 5c (A1456/A1532)"};
        if (platform == "iPhone5,4"){return "iPhone 5c (A1507/A1516/A1526/A1529)"};
        if (platform == "iPhone6,1"){return "iPhone 5s (A1453/A1533)"};
        if (platform == "iPhone6,2"){return "iPhone 5s (A1457/A1518/A1528/A1530)"};
        if (platform == "iPhone7,1"){return "iPhone 6 Plus (A1522/A1524)"};
        if (platform == "iPhone7,2"){return "iPhone 6 (A1549/A1586)"};
        if (platform == "iPhone8,3"){return "iPhoneSE"};
        if (platform == "iPhone8,4"){return "iPhoneSE"};
        if (platform == "iPhone9,1")   {return "国行、日版、港行iPhone 7"};
        if (platform == "iPhone9,2")   {return "港行、国行iPhone 7 Plus"};
        if (platform == "iPhone9,3")   {return "美版、台版iPhone 7"};
        if (platform == "iPhone9,4")   {return "美版、台版iPhone 7 Plus"};
        if (platform == "iPhone10,1")  {return "国行(A1863)、日行(A1906)iPhone 8"};
        if (platform == "iPhone10,4")  {return "美版(Global/A1905)iPhone 8"};
        if (platform == "iPhone10,2")  {return "国行(A1864)、日行(A1898)iPhone 8 Plus"};
        if (platform == "iPhone10,5")  {return "美版(Global/A1897)iPhone 8 Plus"};
        if (platform == "iPhone10,3")  {return "国行(A1865)、日行(A1902)iPhone X"};
        if (platform == "iPhone10,6")  {return "美版(Global/A1901)iPhone X"};
        
        
        if (platform == "iPod1,1"){return "iPod Touch 1G (A1213)"};
        if (platform == "iPod2,1"){return "iPod Touch 2G (A1288)"};
        if (platform == "iPod3,1"){return "iPod Touch 3G (A1318)"};
        if (platform == "iPod4,1"){return "iPod Touch 4G (A1367)"};
        if (platform == "iPod5,1"){return "iPod Touch 5G (A1421/A1509)"};
        if (platform == "iPad1,1"){return "iPad 1G (A1219/A1337)"};
        if (platform == "iPad2,1"){return "iPad 2 (A1395)"};
        if (platform == "iPad2,2"){return "iPad 2 (A1396)"};
        if (platform == "iPad2,3"){return "iPad 2 (A1397)"};
        if (platform == "iPad2,4"){return "iPad 2 (A1395+New Chip)"};
        if (platform == "iPad2,5"){return "iPad Mini 1G (A1432)"};
        if (platform == "iPad2,6"){return "iPad Mini 1G (A1454)"};
        if (platform == "iPad2,7"){return "iPad Mini 1G (A1455)"};
        if (platform == "iPad3,1"){return "iPad 3 (A1416)"};
        if (platform == "iPad3,2"){return "iPad 3 (A1403)"};
        if (platform == "iPad3,3"){return "iPad 3 (A1430)"};
        if (platform == "iPad3,4"){return "iPad 4 (A1458)"};
        if (platform == "iPad3,5"){return "iPad 4 (A1459)"};
        if (platform == "iPad3,6"){return "iPad 4 (A1460)"};
        
        
        if (platform == "iPad4,1"){return "iPad Air (A1474)"};
        if (platform == "iPad4,2"){return "iPad Air (A1475)"};
        if (platform == "iPad4,3"){return "iPad Air (A1476)"};
        
        
        
        if (platform == "iPad4,4"){return "iPad Mini 2G (A1489)"};
        if (platform == "iPad4,5"){return "iPad Mini 2G (A1490)"};
        if (platform == "iPad4,6"){return "iPad Mini 2G (A1491)"};
        if (platform == "iPad4,7"){return "iPad Mini 3 (A1599)"};
        if (platform == "iPad4,8"){return "iPad Mini 3G (A1600)"};
        
        
        
        if (platform == "iPad5.3"){return "iPad air 2 (A1566)"};
        if (platform == "iPad5,4"){return "iPad air 2G (A1567)"};
        
        if (platform == "i386"){return "iPhone Simulator"};
        if (platform == "x86_64"){return "iPhone Simulator"};
        return "不可识别的iPhone型号";
    }() //设备区域化型号如A1533
}


//获取设备唯一标识
let GetUDID:String = {
    let keychain = KeychainSwift()
    let kKeychainUDID = "Noah.Smart.Child.com.UDID"
    if let value = keychain.get(kKeychainUDID) {
        return value
    } else {
        let UDID:String = (UIDevice.current.identifierForVendor?.uuidString)!
        keychain.synchronizable = false
        keychain.set(UDID, forKey: kKeychainUDID)
        return UDID
    }
}()

func GetGUID() -> String! {
    return NSUUID().uuidString
}

func GetIPAddresses() -> String? {
    var addresses = [String]()
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while (ptr != nil) {
            let flags = Int32(ptr!.pointee.ifa_flags)
            var addr = ptr!.pointee.ifa_addr.pointee
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String(validatingUTF8:hostname) {
                            addresses.append(address)
                        }
                    }
                }
            }
            ptr = ptr!.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
    }
    return addresses.first
}

struct NHNotifyName {
    static let AreaUpdated = NSNotification.Name(rawValue: "notify_area_updated")
    static let ReceiveMessage = NSNotification.Name(rawValue: "notify_receive_message")
}

struct Constants {
    static let USER_ID = "constants_user_id"
    static let USER_NAME = "constants_user_name"
    static let USER_PHONE = "constants_user_phone"
    static let DB_VERSION = "constants_db_version"
    
    static let NOW_PROVINCE_CODE = "constants_now_province_code"
}

struct NHTableName {
    static let VersionTable = "nh_version_table"
    static let V_AreaTable = "nh_area_table"
    static let UserTable = "nh_user_table"
}
