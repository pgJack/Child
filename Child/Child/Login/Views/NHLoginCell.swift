//
//  NHLoginCell.swift
//  Child
//
//  Created by Noah on 2018/3/8.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit
public protocol NHLoginDelegate: class {
    
    func didClickSignIn()
    func didClickSignUp()
    
}

class NHLoginBtnCell: UITableViewCell {
    @IBOutlet weak var signBtn: UIButton!
    weak var loginDelegate: NHLoginDelegate?

    var isSignIn:Bool? {
        didSet {
            if signBtn != nil {
                signBtn.setTitle(isSignIn! ? "登录" : "注册", for: UIControlState.normal)
            }
        }
    }
    
    class func getBtnCell() -> NHLoginBtnCell {
        let cell:NHLoginBtnCell = Bundle.main.loadNibNamed("NHLoginCell", owner: nil, options: nil)![1] as! NHLoginBtnCell
        
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        signBtn.layer.cornerRadius = 3.0
        signBtn.layer.masksToBounds = true
    }
    
    @IBAction func didClickSignBtn(_ sender: UIButton) {
        if self.loginDelegate != nil {
            if self.isSignIn != nil && self.isSignIn! == true {
                self.loginDelegate?.didClickSignIn()
            } else {
                self.loginDelegate?.didClickSignUp()
            }
        }
    }
}


class NHLoginCell: UITableViewCell {
    
    var model:NHLoginModel? {
        didSet {
            if model != nil {
            let attributedString = NSMutableAttributedString.init()
            attributedString.append(self.appendColorStrWithString(model!.placeHolder ?? "", 17, NHColor.lightColor))
            infoTxt.attributedPlaceholder = attributedString
            infoTxt.text = model!.value
            infoTxt.keyboardType = model!.keyboardType
            codeBtnWidth.constant = model!.isSendCode ? 44.0 : 0.0
            }
        }
    }
    private func appendColorStrWithString(_ str:String,_ font:CGFloat,_ color:UIColor) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: font),NSAttributedStringKey.foregroundColor:color])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
        return attributedString
    }

    @IBOutlet weak var codeBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var infoTxt: UITextField!
    
    class func getCell(_ model:NHLoginModel!) -> NHLoginCell {
        let cell:NHLoginCell = Bundle.main.loadNibNamed("NHLoginCell", owner: nil, options: nil)![0] as! NHLoginCell
        cell.model = model
        
        return cell
    }
    

    @IBAction func didClickCodeBtn(_ sender: UIButton) {
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        codeBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
