//
//  LinkManager.swift
//  Child
//
//  Created by Noah on 2018/3/22.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa

private let linkUrl = (url:"13.124.243.54",port:Int32(50051))

class LinkManager:NSObject {
    private let UDPLink:UDPClient = {
        var UDPLink = UDPClient(address: linkUrl.url, port: linkUrl.port)
        //        var tv = timeval.init(tv_sec: 10, tv_usec: 0)
        //        if UDPLink.fd != nil {
        //            setsockopt(UDPLink.fd!, SOL_SOCKET, SO_RCVTIMEO, &tv, socklen_t(MemoryLayout<timeval>.size));
        //            setsockopt(UDPLink.fd!, SOL_SOCKET, SO_SNDTIMEO, &tv, socklen_t(MemoryLayout<timeval>.size));
        //        }
        return UDPLink
    }()
    private let TCPLink:TCPClient = {
        var TCPLink = TCPClient(address: linkUrl.url, port: linkUrl.port)
        return TCPLink
    }()
    
    private var UDPThread:Thread?
    
    private let TCPQueue = OperationQueue()
    private var TCPTask:BlockOperation?
    
    static let shareManager: LinkManager = {
        var manager = LinkManager()
        
        //        manager.UDPThread = Thread.init(target: manager, selector: #selector(UDPListen), object: nil)
        //        manager.UDPThread!.name = "udp_thread"
        //        manager.UDPThread!.start()
        NotificationCenter.default.addObserver(manager, selector: #selector(manager.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: AppDelegate.sharedDelegate().reachability)
        manager.TCPQueue.name = "nh_tcp_queue"
        return manager
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 主动检测网络状态
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        if reachability.connection != .none { // 判断网络连接状态
            print("网络连接：可用")
            LinkManager.startLink()
            if reachability.connection == .wifi { // 判断网络连接类型
                print("连接类型：WiFi")
//                 getHostAddress_WLAN() // 获取主机IP地址 192.168.31.2
            } else {
                print("连接类型：移动网络")
                // getHostAddrss_GPRS()  // 通过外网获取主机IP地址
            }
        } else {
            print("网络连接：不可用")
        }
    }

    func getTCPTask() -> BlockOperation {
        if TCPTask != nil {
            TCPTask!.cancel()
        }
        TCPTask = BlockOperation()
        TCPTask!.name = "nh_tcp_task"
        TCPTask!.addExecutionBlock {
            self.TCPConnect(self.TCPTask!)
        }
        return TCPTask!
    }
    
    class func startLink() {
        let queue = shareManager.TCPQueue
        DispatchQueue.global().async {
            queue.addOperations([shareManager.getTCPTask()], waitUntilFinished: false)
        }
    }
    
    @discardableResult
    func Register() -> Result {
        let data = "1,2\r\n".data(using: .utf8)
        let result = TCPLink.send(data:data!)
        return result
    }
    @discardableResult
    func Logout() -> Result {
        let data = "1,2\r\n".data(using: .utf8)
        let result = TCPLink.send(data:data!)
        return result
    }
    @discardableResult
    func Pulse() -> Result {
        let data = "1,2\r\n".data(using: .utf8)
        let result = TCPLink.send(data:data!)
        return result
    }
}
//TCP
extension LinkManager {
    
    @objc func TCPConnect(_ operation:BlockOperation) {
        if operation.isCancelled {return}
        TCPLink.close()
        let result = TCPLink.connect(timeout: 20)
        if result.error != nil {
            print("TCP connect error \(String(describing: result.error))")
            sleep(30)
            TCPConnect(operation)
        } else {
            print("TCP connect success \(String(describing: TCPLink.fd))")
            Register()
            Reading(operation)
        }
    }
    func TCPBreath(_ pulse:Int, _ operation:BlockOperation) {
        if operation.isCancelled {return}
        let result = Pulse()
        if result.error != nil {
            print("TCP wake laoPa error \(String(describing: result.error))")
            sleep(10)
            let nextPluse = pulse - 1
            if nextPluse==0 {
                TCPConnect(operation)
            } else {
                TCPBreath(nextPluse,operation)
            }
        } else {
            print("TCP wake laoPa success")
            Reading(operation)
        }
    }
    func Reading(_ operation:BlockOperation) {
        let recvResult = TCPLink.read(1024,timeout: 300)
        if operation.isCancelled {return}
        if  recvResult != nil {
            DispatchQueue.global().async {
                let recvData = Data.init(bytes: recvResult!)
                let recvString = String.init(data: recvData, encoding: String.Encoding.utf8) ?? ""
                print("TCP receive from laoPa "+(recvString))
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NHNotifyName.ReceiveMessage, object: recvString)
                }
            }
            Reading(operation)
        } else {
            TCPBreath(3,operation)
        }
    }
}


//UDP
extension LinkManager {

    @objc func UDPListen() {
        while true {
            let recvResult = UDPLink.recv(1024)
            if recvResult.0 != nil {
                DispatchQueue.global().async {
                    let recvData = Data.init(bytes: recvResult.0!)
                    let recvString = String.init(data: recvData, encoding: String.Encoding.utf8) ?? ""
                    print("UDP receive from laoPa "+(recvString))
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NHNotifyName.ReceiveMessage, object: recvString)
                    }
                }
            } else {
                sleep(10)
            }
        }
    }
    func UDPBreath() {
        let result = UDPLink.send(string: "1,2")
        if result.error != nil {
            print("UDP wake laoPa error \(String(describing: result.error))")
        } else {
            print("UDP wake laoPa success")
        }
    }

}

//SendMessage
extension LinkManager {
    func sendMessage(_ message:LMessage,_ transType:Bool = true) {
        if transType {
            let result = TCPLink.send(data: message.data)
            print("TCP receive after send\(result)")
        } else {
            let result = UDPLink.send(data: message.data)
            print("UDP receive after send\(result)")
        }
    }
}


