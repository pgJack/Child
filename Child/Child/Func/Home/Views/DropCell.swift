//
//  DropCell.swift
//  Child
//
//  Created by Noah on 2018/3/6.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

fileprivate let cellID = "drop_table_cell"
let dropCellHeight:CGFloat = 50.0


class DropCell: UITableViewCell {
    
    @IBOutlet weak var dropTitle: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    var model:CellElement! {
        didSet {
            dropTitle.text = model.title

            if model.isSelected {
                dropTitle.textColor = NHColor.mainColor
                selectBtn.isSelected = true;
            } else {
                dropTitle.textColor = NHColor.grayColor
                selectBtn.isSelected = false;
            }
        }
    }
    
    class func getCell(_ tableView:UITableView, _ model:CellElement!) -> DropCell {
        
        var cell:DropCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? DropCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("DropDownViews", owner: nil, options: nil)![3] as? DropCell
        }
        cell?.model = model
        
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropTitle.font = NHFont.normalFont
        backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
