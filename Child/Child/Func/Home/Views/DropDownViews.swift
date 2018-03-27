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
    class func getDropView(model:NHDropDownModel, delegate:NHDropDownDelegate?) -> DropRootView {
        
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
        for i in 0..<elements.count {
            if Unmanaged.passUnretained(elements[i]).toOpaque() == Unmanaged.passUnretained(elements[indexPath.row]).toOpaque() {
                elements[i].isSelected = true
            } else {
                elements[i].isSelected = false
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
            return model.dataArray[1].1.count
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
            let element = model.dataArray[1].1[indexPath.row]
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
        for i in 0..<leftElements.count {
            leftElements[i].isSelected = false
        }
        leftElements[index].isSelected = true
        leftTableView.reloadData()
        resetRightTable()
    }
    
    func selectRightCell(index:Int) {
        if model.dataArray[1].1[index].isSelected {return}
        var rightElements = model.dataArray[1].1
        for i in 0..<rightElements.count {
            rightElements[i].isSelected = false
        }
        model.dataArray[1].1[index].isSelected = true
        rightTableView.reloadData()
    }
    
    func resetRightTable() {
        let leftElements = model.dataArray[0].1
        var rightElements = [CellElement]()
        var parentCode:Int?
        for element in leftElements {
            if element.isSelected {
                parentCode = element.code
                break
            }
        }
        if parentCode != nil {
            let towns = AreaManager.share.nowTowns(cityCode: String.init(format: "%d", parentCode!))
            if UnEmptyArray(towns) {
                rightElements.append(CellElement.init(towns![0].name, code: Int(towns![0].code), parentCode: Int(towns![0].parentCode)!))
                for i in 1..<towns!.count {
                    rightElements.append(CellElement.init(towns![i].name, code: Int(towns![i].code), parentCode: Int(towns![i].parentCode)!))
                }
            }
        }
        model.dataArray[1].1 = rightElements
        if rightElements.count > 0 {
            selectRightCell(index: 0)
        } else {
            rightTableView.reloadData()
        }
    }
    
    func resetAll() {
        var leftElements = [CellElement]()
        let citys = AreaManager.share.nowCitys()
        
        citys?.forEach({ (city) in
            leftElements.append(CellElement.init(city.name, code: Int(city.code), parentCode: Int(city.parentCode)!))
            
        })
        if UnEmptyArray(leftElements) {
            leftElements[0].isSelected = true;
            leftElements[0].isDefaultSelected = true
        }
        model.dataArray[0].1 = leftElements
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
