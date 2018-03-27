//
//  NHLoginController.swift
//  Child
//
//  Created by Noah on 2018/3/8.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHLoginController: NHTableViewController {

    convenience init(style: UITableViewStyle = UITableViewStyle.plain, _ isSignIn:Bool) {
        self.init(style: style)
        self.isSignIn = isSignIn
    }
    
    var nowNav: NHNavigationController?
    var isSignIn:Bool = false
    var signBtn:NHLoginBtnCell = NHLoginBtnCell.getBtnCell()
    
    let signUpArray:[NHLoginCell] = [
        NHLoginCell.getCell(NHLoginModel("手机号","",false,UIKeyboardType.numberPad)),
        NHLoginCell.getCell(NHLoginModel("输入密码","")),
        NHLoginCell.getCell(NHLoginModel("确认密码","")),
        NHLoginCell.getCell(NHLoginModel("短信验证码","",true))
    ]
    let signInArray:[NHLoginCell] = [
        NHLoginCell.getCell(NHLoginModel("手机号","",false,UIKeyboardType.numberPad)),
        NHLoginCell.getCell(NHLoginModel("输入密码","")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowNav = AppDelegate.nowNavController()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
        let image = UIImage.init(named: "login_backgroundImage.jpg")
        let imageView = UIImageView.init(image: image)
        tableView.backgroundView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowNav?.NoColorNav()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nowNav?.NoColorNav()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("dead")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NHLoginController:NHLoginDelegate {
    func didClickSignIn() {
        let phoneNum = signInArray[0].infoTxt.text
        let password = signInArray[1].infoTxt.text
        
        if !IsPhoneNumber(phoneNum) {NHAlertView.noticeShow("请输入正确手机号"); return}
        if IsEmptyString(password) {NHAlertView.noticeShow("请设置密码"); return}
        
        let params = [
            "phone" : phoneNum!,
            "login_password" : password!,
            ]
        NHNet.share.POST(url: NHURL.LoginURL(),code: NHSignCode().IN, params: params) { (code, result) in
            if result != nil && result is Dictionary<String, Any> {
                var userInfo = result as! Dictionary<String, Any>
                let user = userInfo["user"]
                let token = userInfo["token"]
                let userDict = JSON.init(parseJSON:user as! String).rawValue
                NHUser.share.setValuesForKeys(userDict as! [String : Any])
                NHData.share.token = token as? String
            }
        }
    }
    
    func didClickSignUp() {
        
        let phoneNum = signUpArray[0].infoTxt.text
        let password = signUpArray[1].infoTxt.text
        let cherkPassword = signUpArray[2].infoTxt.text
        let messageCode = signUpArray[3].infoTxt.text
        
        if !IsPhoneNumber(phoneNum) {NHAlertView.noticeShow("请输入正确手机号"); return}
        if IsEmptyString(password) {NHAlertView.noticeShow("请设置密码"); return}
        if !IsEquelString(password, cherkPassword) {NHAlertView.noticeShow("两次输入密码不一致\n请确认后重试"); return}
        if IsEmptyString(messageCode) {NHAlertView.noticeShow("请输入短信验证码"); return}
        
        let params = [
            "phone" : phoneNum!,
            "login_password" : password!,
            ]
        NHNet.share.POST(url: NHURL.LoginURL(),code: NHSignCode().UP, params: params) { (code, result) in
            if result != nil {
                let signInCtr = NHLoginController.init(true)
                self.navigationController?.pushViewController(signInCtr, animated: true)
            }
            
        }
        
        


    }
    
    class func SignOut() {
        NHNet.share.POST(url: NHURL.LoginURL(),code: NHSignCode().OUT, params: nil) { (code, result) in
            print("\(code).....result\(String(describing: result))")
        }
    }
    
    
    // MARK: - Table view data source
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isSignIn ? signInArray.count : signUpArray.count) + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellArray = isSignIn ? signInArray : signUpArray
        
        if cellArray.count <= indexPath.row {
            signBtn.isSignIn = isSignIn
            signBtn.loginDelegate = self
            return signBtn
        } else {
            return cellArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellArray = isSignIn ? signInArray : signUpArray
        
        if cellArray.count <= indexPath.row {
            return 80.0
        } else {
            return 50.0
        }
    }
    
}
