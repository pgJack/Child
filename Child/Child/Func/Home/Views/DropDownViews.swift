//
//  ZBDropDownMenu.swift
//  Child
//
//  Created by Noah on 2018. 2. 27..
//  Copyright © 2018年 Noah. All rights reserved.
//

import UIKit
import YNDropDownMenu

class DropRootView: YNDropDownView {
    open var model: NHDropDownModel!
    open weak var dropDelegate: NHDropDownDelegate?
    class func getDropView(model:NHDropDownModel, delegate:NHDropDownDelegate) -> DropRootView {
        
        var dropView:DropRootView?
        
        switch model.style {
        case .rule:
            dropView = Bundle.main.loadNibNamed("DropDownViews", owner: nil, options: nil)![0] as? NHSortRuleView
        case .area:
            dropView = Bundle.main.loadNibNamed("DropDownViews", owner: nil, options: nil)![1] as? NHAreaView
        case .feature:
            dropView = Bundle.main.loadNibNamed("DropDownViews", owner: nil, options: nil)![2] as? NHFeaturesView
        default:
            dropView = Bundle.main.loadNibNamed("DropDownViews", owner: nil, options: nil)![0] as? NHSortRuleView
        }
        
        
        if model.height > 0.0 {
            dropView?.bounds.size.height = model.height
        }
        dropView?.model = model
        dropView?.dropDelegate = delegate
        
        return dropView!
    }
}


class NHSortRuleView: DropRootView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellID:String = "sort_rule_cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.dataArray.count < 0 {
            return 0
        } else {
            return model.dataArray[0].1.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element:CellElement = model.dataArray[0].1[indexPath.row]
        return DropCell.getCell(tableView, element)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        var elements = model.dataArray[0].1
        for i in 1...elements.count {
            if Unmanaged.passUnretained(elements[i - 1]).toOpaque() == Unmanaged.passUnretained(elements[indexPath.row]).toOpaque() {
                elements[i - 1].isSelected = true
            } else {
                elements[i - 1].isSelected = false
            }
        }
        tableView.reloadData()
        dropDelegate?.didSelectItem(model: model)
    }
    
    override func dropDownViewOpened() {
        
    }
    
    override func dropDownViewClosed() {
        
    }
}

class NHAreaView: DropRootView,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var leftTableView: UITableView!
    let leftCellID:String = "left_area_cell"
    let rightCellID:String = "right_area_cell"
    var rightElementsShow:Array = [CellElement]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftTableView.delegate = self
        leftTableView.dataSource = self
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.backgroundColor = NHColor.backlightColor
    }
    
    override var model:NHDropDownModel! {
        didSet{
            resetAll()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return model.dataArray[0].1.count
        } else {
            return rightElementsShow.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == leftTableView {
            let element = model.dataArray[0].1[indexPath.row]
            let cell = DropCell.getCell(tableView, element)
            if element.isSelected {
                cell.backgroundColor = NHColor.backlightColor
            } else {
                cell.backgroundColor = UIColor.clear
            }
            return cell
        } else {
            let element = rightElementsShow[indexPath.row]
            let cell = DropCell.getCell(tableView, element)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if tableView == leftTableView {
            selectLeftCell(index: indexPath.row)
        } else {
            selectRightCell(index: indexPath.row)
        }
    }
    
    func selectLeftCell(index:Int) {
        var leftElements = model.dataArray[0].1
        if leftElements[index].isSelected {return}
        for i in 1...leftElements.count {
            leftElements[i - 1].isSelected = false
        }
        leftElements[index].isSelected = true
        leftTableView.reloadData()
        resetRightTable()
    }
    
    func selectRightCell(index:Int) {
        if rightElementsShow[index].isSelected {return}
        var rightElements = model.dataArray[1].1
        for i in 1...rightElements.count {
            rightElements[i - 1].isSelected = false
        }
        rightElementsShow[index].isSelected = true
        rightTableView.reloadData()
    }
    
    func resetRightTable() {
        let leftElements = model.dataArray[0].1
        var rightElements = model.dataArray[1].1
        var parentCode:Int?
        for element in leftElements {
            if element.isSelected {
                parentCode = element.code
                break
            }
        }
        rightElementsShow.removeAll()
        for i in 1...rightElements.count {
            let element = rightElements[i - 1]
            element.isSelected = false
            if element.parentCode == parentCode {
                rightElementsShow.append(element)
            }
        }
        if rightElementsShow.count > 0 {
            selectRightCell(index: 0)
        }
    }
    
    func resetAll() {
        var leftElements = model.dataArray[0].1
        for i in 1...leftElements.count {
            leftElements[i - 1].isSelected = leftElements[i - 1].isDefaultSelected
        }
        leftTableView.reloadData()
        resetRightTable()
    }
    
    @IBAction func didClickReset(_ sender: Any) {
        resetAll()
    }
    
    @IBAction func didClickDone(_ sender: Any) {
        dropDelegate?.didSelectItem(model: model)
    }
    
    @IBAction func didClickChangeCity(_ sender: UIButton) {
        dropDelegate?.didClickChooseProvince()
    }
}

class NHFeaturesView: DropRootView {
    
    @IBAction func didClickReset(_ sender: Any) {
        
    }
    
    @IBAction func didClickDone(_ sender: Any) {
        
    }

}
