//
//  DropTableView.swift
//  Child
//
//  Created by Noah on 2018/3/6.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class DropTableView: UITableView {

    override func awakeFromNib() {
        separatorStyle = UITableViewCellSeparatorStyle.none
        rowHeight = dropCellHeight
    }
}
