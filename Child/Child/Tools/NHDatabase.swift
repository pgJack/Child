//
//  NHDatabase.swift
//  Child
//
//  Created by Noah on 2018/3/11.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit
import SQLite

enum SQLType:Int {
    case creat
    case insert
    case delete
    case update
    case query
    case drop
}

struct Database {
    
    static let DB_VERSION = 1
    
    static let shareDB = Database()
    private var db:Connection!
    
    let DBName = "database.sqlite3"
    
    init() {
        openDB()
        if Database.DB_VERSION > SystemPreferences().integer(forKey: Constants.DB_VERSION) {
            SyncVersion()
        }
    }
    
    func SyncVersion() {
        if Database.DB_VERSION == 1 {
            creat(sql: "CREATE TABLE IF NOT EXISTS \(NHTableName.VersionTable) (tableName text PRIMARY KEY,nowVersion text,newVersion text)")
            creat(sql: "CREATE TABLE IF NOT EXISTS \(NHTableName.V_AreaTable) (name text,code text PRIMARY KEY,parentCode text,type text)")
            creat(sql: "CREATE TABLE IF NOT EXISTS \(NHTableName.UserTable) (name text,userId text PRIMARY KEY,phone text)")
        }
        SystemPreferences().set(Database.DB_VERSION, forKey: Constants.DB_VERSION)
    }
    
    //初始化方法打开数据库
    mutating func openDB() {
        do {
            let sqlFilePath = DocPath.appendingPathComponent(DBName)
            db = try Connection(sqlFilePath)
            print("打开数据库成功")
        } catch {
            print("打开数据库失败")
        }
    }
    
    // 建表
    func creat(sql: String,dropTable: String = "") {
        if UnEmptyString(dropTable) {
            drop(table: dropTable)
        }
        executeSQL(.creat, sql)
    }
    // 插入
    func insert(sql: String, args:[Binding?]) {
        if !sql.hasSuffix(";") || (!sql.contains("values(") && !sql.contains("values (")) {
            var tempString = " values("
            for _ in 0..<args.count {
                tempString += "?,"
            }
            tempString.remove(at: tempString.index(before: tempString.endIndex))
            tempString += ");"
            executeSQL(.insert, sql+tempString, args)
        } else {
            executeSQL(.insert, sql, args)
        }
    }
    func insert(sql: String, args:Binding?...) {
        insert(sql: sql, args: args)
    }
    // 读取
    func query(sql: String, args:[Binding?]) -> [[String:Any]] {
        
        var resultArray = [[String:Any]]()
        do {
            let result = try db.prepare(sql)
            for item in result {
                var resultDict = [String:Any]()
                for i in 0..<result.columnNames.count {
                    resultDict[result.columnNames[i]] = item[i] as Any
                }
                resultArray.append(resultDict)
            }
            print("查询:\(sql) \(resultArray.count)条结果")
        } catch {
            print("查询:\(sql) 失败")
        }
        return resultArray
    }
    func query(sql: String, args:Binding?...) -> [[String:Any]] {
        return query(sql: sql, args: args)
    }
    
    // 更新
    func update(sql:String, args:Binding?...) {
        executeSQL(.update, sql, args)
    }
    
    @discardableResult
    func executeSQL(_ type:SQLType,_ sql:String,_ args:Binding?... ) -> Bool {
        return executeSQL(type, sql, args)
    }
    
    @discardableResult
    func executeSQL(_ type:SQLType,_ sql:String,_ args:[Binding?] ) -> Bool {
        do {let result = try db.run(sql,args)
            print("TYPE:\(type) 处理成功: \(result)")
            return true
        } catch {
            print("TYPE:\(type) 处理失败：\(error)")
            return false
        }
    }
    
    // 删表
    @discardableResult
    func drop(table: String) -> Bool {
        let sql = "select count(1) countNum from sqlite_master where type = 'table' and name = '\(table)';"
        let tableList = query(sql: sql)
        if tableList.count > 0 {
            if let countNum = tableList[0]["countNum"] as? String {
                if Int(countNum)! > 0 {
                    return executeSQL(.update, "drop table \(table)")
                }
            } else if let countNum = tableList[0]["countNum"] as? Int {
                if countNum > 0 {
                    return executeSQL(.update, "drop table \(table)")
                }
            }
        } else {
            print("无表 \(table)")
        }
        return true
    }
    // 清表
    @discardableResult
    func delete(table: String) -> Bool {
        return executeSQL(.delete, "delete from \(table) where 1=1")
    }
    func delete(sql: String) -> Bool {
        return executeSQL(.delete, sql)
    }
    mutating func deleteAllTable() {
        cleanDocItem(DBName)
        openDB()
    }
}
