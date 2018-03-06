//
//  NHHomePageController.swift
//  Child
//
//  Created by Noah on 2018/2/24.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit
import YNDropDownMenu
class NHHomePageController: NHViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headView: UIView!
    
    var location:BMKLocation?
    var dropMenu:YNDropDownMenu?
    let dropModels:[NHDropDownModel] = {
        var ruleData:Array = [
            (("",0),[
                CellElement.init("推荐", code: 1, parentCode: -1, isSelected:true),
                CellElement.init("最新", code: 2, parentCode: -1),
                ])
        ]
        var ruleModel:NHDropDownModel = NHDropDownModel.init(ruleData, NHDropDownStyle.rule, NHDropSelectStyle.single, dropCellHeight * 2)
        
        var areaData:Array = [
            (("city",0),[
                CellElement.init("北京市", code: 1, parentCode: -1, isSelected:true),
                CellElement.init("上海市", code: 2, parentCode: -1)
                ]),
            (("district",0),[
                CellElement.init("昌平区", code: 1, parentCode: 1, isSelected:true),
                CellElement.init("海淀区", code: 2, parentCode: 1),
                CellElement.init("尖沙咀区", code: 1, parentCode: 2),
                CellElement.init("浦东区", code: 2, parentCode: 2)
                ])
        ]
        var AreaModel:NHDropDownModel = NHDropDownModel(areaData, NHDropDownStyle.area, NHDropSelectStyle.single, dropCellHeight * 5 + 66)
        var featuresData:Array = [
            (("品种",0),[
                CellElement.init("花花牛", code: 1, parentCode: -1, isSelected:true),
                CellElement.init("红富士", code: 2, parentCode: -1)
                ]),
            (("规格",0),[
                CellElement.init("111", code: 1, parentCode: -1, isSelected:true),
                CellElement.init("红富士", code: 2, parentCode: -1)
                ]),
            (("颜色",0),[
                CellElement.init("表光", code: 1, parentCode: -1, isSelected:true),
                CellElement.init("条红", code: 2, parentCode: -1)
                ])
        ]
        var FeaturesModel:NHDropDownModel = NHDropDownModel(featuresData, NHDropDownStyle.feature, NHDropSelectStyle.single, dropCellHeight * 5 + 34)
        var array:Array = [ruleModel,AreaModel,FeaturesModel]
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
        // Do any additional setup after loading the view.
    }
    
    private func creatUI() {
        self.title = "大厅"
        NHLocationManager.shareManager.startlocation { (location) in
            self.location = location
            if self.dropMenu != nil {
                self.dropMenu?.changeMenu(title: location?.rgcData?.city ?? "地区", at: 1)
            }
        }
        self.prepareTableView()
        self.prepareHeadView()
        
        let leftItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(didClickBack(_:)))
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(didClickBack(_:)))
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
    }

    @objc private func didClickBack(_ btn:UIButton) {
        NHLocationManager.shareManager.startlocation { (location) in
            self.location = location
            if self.dropMenu != nil {
                self.dropMenu?.changeMenu(title: location?.rgcData?.city ?? "地区", at: 1)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: UITableViewDelegate UITableViewDataSource
extension NHHomePageController:UITableViewDelegate,UITableViewDataSource {
    
    func prepareTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = "index row is \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NHNet.share.GET(parameters: ["":""]) { (code, result) in
            
        }
    }
    
}

//MARK: HeadView
extension NHHomePageController:NHDropDownDelegate, NHProvinceDelegate {
    func didSelectProvince(model: CellElement) {
        
        
        var elements = self.dropModels[1].dataArray[0].1
        if model.code == 0 {
            elements[0].isSelected = true
            elements[1].isSelected = false
        } else {
            elements[0].isSelected = false
            elements[1].isSelected = true
        }
        var areaData:Array = [
            (("city",0),[
                CellElement.init("海南市", code: 1, parentCode: -1, isSelected:true),
                CellElement.init("福建市", code: 2, parentCode: -1)
                ]),
            (("district",0),[
                CellElement.init("昌平区", code: 1, parentCode: 1, isSelected:true),
                CellElement.init("海淀区", code: 2, parentCode: 1),
                CellElement.init("尖沙咀区", code: 1, parentCode: 2),
                CellElement.init("浦东区", code: 2, parentCode: 2)
                ])
        ]
        var model:NHDropDownModel = dropModels[1]
        model.dataArray = areaData
        self.dropMenu?.changeView(view: DropRootView.getDropView(model: model, delegate: self), at: 1)

        didSelectItem(model: model)
    }
    
    func didSelectItem(model: NHDropDownModel) {
        switch model.style {
        case .rule:
            let elements = model.dataArray[0].1
            elements.forEach({ (element) in
                if element.isSelected {self.dropMenu?.changeMenu(title: element.title!, at: 0);return}
            })
            break
            
        case .area:
            let elements = model.dataArray[0].1
            elements.forEach({ (element) in
                if element.isSelected {self.dropMenu?.changeMenu(title: element.title!, at: 1);return}
            })
            break
            
        case .feature:
            let elements = model.dataArray[0].1
            elements.forEach({ (element) in
                if element.isSelected {self.dropMenu?.changeMenu(title: element.title!, at: 2);return}
            })
            break
            
        default:break
        }
        
        dropMenu?.hideMenu()
    }
    
    func didClickChooseProvince() {
        
        let proCtr = DropProvinceController.init(style: UITableViewStyle.plain)
        navigationController?.pushViewController(proCtr, animated: true)
        proCtr.proDelegate = self
        dropMenu?.hideMenu()
    }
    
    func prepareHeadView() {
        
        let ZBdropDownViews:[DropRootView] = {
            
            var array = Array<DropRootView>()
            
            dropModels.forEach({ (model) in
                array .append(DropRootView.getDropView(model: model, delegate: self))
            })
            return array
        }()
        
        let dropMenu = YNDropDownMenu(frame: self.headView.frame, dropDownViews:ZBdropDownViews, dropDownViewTitles: ["推荐", self.location?.rgcData?.city ?? "地区", "要求"])
        dropMenu.setImageWhen(normal: UIImage(named: "arrow_down"), selected: UIImage(named: "arrow_down"), disabled: UIImage(named: "arrow_down"))
        dropMenu.setLabelColorWhen(normal: NHColor.grayColor, selected: NHColor.mainColor, disabled: NHColor.lightColor)
        dropMenu.setLabelFontWhen(normal: NHFont.normalFont, selected: NHFont.normalFont, disabled: NHFont.normalFont)
        dropMenu.backgroundBlurEnabled = true
        dropMenu.bottomLine.isHidden = false
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        dropMenu.blurEffectView = backgroundView
        dropMenu.blurEffectViewAlpha = 0.7
        dropMenu.setBackgroundColor(color: UIColor.white)
        
        self.dropMenu = dropMenu
        view.addSubview(dropMenu)
    }
    
}

