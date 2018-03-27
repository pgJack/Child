//
//  NHVersion.swift
//  Child
//
//  Created by Noah on 2018/3/12.
//  Copyright © 2018年 NH. All rights reserved.
//

import Foundation


struct SyncVersion {
    let versionTable = NHTableName.VersionTable
    let TableKey = "tableName"
    let VerKey = "version"
    
    func SyncFromNet() {
        let newVersions = [[TableKey:NHTableName.UserTable,VerKey:"1"],
                            [TableKey:NHTableName.V_AreaTable,VerKey:"2"]]
        
        newVersions.forEach { (versionDict) in
            SyncVersion.insert(tableName: versionDict[TableKey]!, newVersion: versionDict[VerKey]!)
        }
    }
    
    
    static func query(tableName:String) -> (newVersion: String, nowVersion:String)? {
        let version = Database.shareDB.query(sql: "select * from \(NHTableName.VersionTable) where tableName = '\(tableName)';")
        if UnEmptyArray(version) {
            let newVer = version[0]["newVersion"] as! String
            let nowVer = version[0]["nowVersion"] as! String
            return (newVer,nowVer)
        } else {
            return nil
        }
    }
    static func insert(tableName:String, newVersion:String) {
        Database.shareDB.insert(sql: "insert or replace into \(NHTableName.VersionTable) (tableName,newVersion,nowVersion)", args: [tableName,newVersion,newVersion])
    }
}

