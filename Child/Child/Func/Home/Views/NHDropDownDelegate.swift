//
//  DropDownViewDelegate.swift
//  Child
//
//  Created by Noah on 2018/3/5.
//  Copyright © 2018年 NH. All rights reserved.
//

import Foundation
import UIKit

/// Delegate to get call back
public protocol NHDropDownDelegate: class {
    
    func didSelectItem(model:NHDropDownModel)
    func didClickChooseProvince()
}
