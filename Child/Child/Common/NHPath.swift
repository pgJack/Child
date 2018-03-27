//
//  NHPath.swift
//  Child
//
//  Created by Noah on 2018/3/4.
//  Copyright © 2018年 NH. All rights reserved.
//

import Foundation

// 存储
func SystemPreferences() -> UserDefaults {
    return UserDefaults.standard
}

//路径
let Default_FileManager: FileManager = FileManager.default

let DocPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString

func getDocDirectory(_ path:String, _ isCreat:Bool = true) -> NSString? {
    let DirPath = DocPath.appendingPathComponent(path)
    if !Default_FileManager.fileExists(atPath: DirPath) {
        if !isCreat {return DirPath as NSString}
        let done:()? = try? Default_FileManager.createDirectory(atPath: DirPath, withIntermediateDirectories: true, attributes: nil)
        if done == nil {
            print("\(DirPath)创建路径失败")
            return nil
        }
    }
    return DirPath as NSString
}

func saveToDocPath(_ data: Data, _ path: String) -> Bool {
    let done:()? = try? data.write(to: URL(fileURLWithPath: path))
    if done == nil {
        print("\((path as NSString).lastPathComponent)保存失败")
    }
    return done != nil
}

@discardableResult
func cleanDocItem(_ path: String) -> Bool {
    let ItemPath = DocPath.appendingPathComponent(path)
    let done:()? = try? Default_FileManager.removeItem(atPath: ItemPath)
    if done == nil {
        print("\(ItemPath)清除路径失败")
    }
    return done != nil
}
//缓存
struct NHCache {
    
    fileprivate static let rootPath:String = "app_cache"
    
    static func imagePath() -> NSString {
        return (getDocDirectory("\(NHCache.rootPath)/save_images") ?? "") as NSString
    }
    static func videoPath() -> NSString {
        return (getDocDirectory("\(NHCache.rootPath)/save_videos") ?? "") as NSString
    }
    
    @discardableResult
    static func saveImage(_ image:UIImage?, _ pictureName:String) -> Bool {
        if image == nil {return false}
        let data:Data? = UIImagePNGRepresentation(image!)
        if data == nil {return false}
        let path:String = NHCache.imagePath().appendingPathComponent(pictureName)
        return saveToDocPath(data!, path)
    }
    @discardableResult
    static func cleanCache() -> Bool {
        return cleanDocItem(NHCache.rootPath)
    }
}
//数据
struct NHPersistence {
    
    fileprivate static let rootPath:String = "app_persistence"
    
    static func userPath() -> NSString {
        return (getDocDirectory("\(NHPersistence.rootPath)/save_users") ?? "") as NSString
    }
    static func tenantPath() -> NSString {
        return (getDocDirectory("\(NHPersistence.rootPath)/save_tenants") ?? "") as NSString
    }
    static func productPath() -> NSString {
        return (getDocDirectory("\(NHPersistence.rootPath)/save_products") ?? "") as NSString
    }
    @discardableResult
    static func cleanCache() -> Bool {
        return cleanDocItem(NHCache.rootPath)
    }
}
