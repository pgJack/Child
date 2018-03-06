//
//  NHDropDownModel.swift
//  Child
//
//  Created by Noah on 2018/3/5.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

typealias SecDatas = ((String, Int), [CellElement])

public enum NHDropDownStyle:Int {
    /// 单列表
    case rule
    
    /// 联动
    case area
    
    /// 流式布局
    case feature
}

public enum NHDropSelectStyle:Int {
    /// 多选
    case single
    /// 单选
    case multi
}

public class CellElement {
    
    init(_ title:String, code:Int!, parentCode:Int = -1, isSelected:Bool = false) {
        self.title = title
        self.code = code
        self.parentCode = parentCode
        self.isSelected = isSelected
        self.isDefaultSelected = isSelected
    }
    
    var title: String?
    var code: Int!
    var parentCode: Int!
    var isSelected: Bool!
    var isDefaultSelected: Bool!
}
public class NHDropDownModel {

    init(_ dataArray:[SecDatas]!, _ style:NHDropDownStyle!, _ selectStyle:NHDropSelectStyle = NHDropSelectStyle.single, _ height:CGFloat = 0.0) {
        self.dataArray = dataArray
        self.style = style
        self.selectStyle = selectStyle
        self.height = height
    }
    
    var dataArray:[SecDatas]!
    var style:NHDropDownStyle!
    var selectStyle:NHDropSelectStyle!
    var height:CGFloat!
}
