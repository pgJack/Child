//
//  NHTheme.swift
//  Child
//
//  Created by Noah on 2018/2/24.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHTheme: NSObject {
    class func setupTheme() {
        let navAppear = UINavigationBar.appearance();
        // Bar's background color
        navAppear.barTintColor = NHColor.mainColor
        // Back button and such
        navAppear.tintColor = NHColor.whiteColor
        // Title's text color
        navAppear.titleTextAttributes = [NSAttributedStringKey.foregroundColor:NHColor.whiteColor,NSAttributedStringKey.font:NHFont.largeFont]
        
        let tabbarAppear = UITabBar.appearance();
        tabbarAppear.tintColor = NHColor.mainColor
    }
}

struct NHFont {
    //粗大字体
    static let boldLargeFont = UIFont.init(name: "Helvetica-Bold", size: 18.0) ?? UIFont.boldSystemFont(ofSize: 18.0)
    //大字体
    static let largeFont = UIFont.systemFont(ofSize: 18.0)
    //粗中字体
    static let boldMidFont = UIFont.init(name: "Helvetica-Bold", size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16.0)
    //中字体
    static let midFont = UIFont.systemFont(ofSize: 16.0)
    //内容字体, 常用
    static let normalFont = UIFont.systemFont(ofSize: 14.0)
    //小字体, 说明内容字体
    static let minFont = UIFont.systemFont(ofSize: 12.0)
}

struct NHColor {
    //Main
    static let mainColor = HexRGBColor(0x21B4B4)    //主题色
    
    //Font
    static let blackColor = HexRGBColor(0x000000)   //黑
    static let grayColor = HexRGBColor(0x919191)    //灰色
    static let lightColor = HexRGBColor(0xc6c6c6)   //浅色
    static let whiteColor = HexRGBColor(0xffffff)   //白色
    static let redColor = HexRGBColor(0xff1212)     //醒目红色
    
    //Button
    static let buttonNormalColor = mainColor              //按钮颜色
    static let buttonHighColor = HexRGBColor(0x1396A0)    //高亮颜色
    static let buttonWarningColor = HexRGBColor(0x1396A0) //警告颜色
    static let buttonDangerColor = HexRGBColor(0x1396A0)  //高危颜色
    
    static let borderColor = HexRGBColor(0xc7c7cc)    //分割线, 边框颜色
}

func HexRGBColor(_ rgb:integer_t,_ alpha:CGFloat = 1.0) -> UIColor
{
    return UIColor(red:CGFloat((rgb >> 16)&0xff)/255.0, green:CGFloat((rgb >> 8)&0xff)/255.0, blue:CGFloat(rgb&0xff)/255.0, alpha: alpha)
}
