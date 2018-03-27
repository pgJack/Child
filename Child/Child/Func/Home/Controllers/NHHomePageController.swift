//
//  NHHomePageController.swift
//  Child
//
//  Created by Noah on 2018/2/24.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit
import YNDropDownMenu

class NHHomePageController: NHViewController,NHDropDownDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headView: UIView!
    
    var lists = [String]()
    
    var location:BMKLocation?
    var dropMenu:YNDropDownMenu?
    let dropDownViews:[DropRootView] = {
        var ruleData:Array = [
            (("",0),[
                CellElement.init("推荐", code: 1, parentCode: -1, isSelected:true),
                CellElement.init("最新", code: 2, parentCode: -1),
                ])
        ]
        var ruleModel:NHDropDownModel = NHDropDownModel.init(ruleData, NHDropDownStyle.rule, NHDropSelectStyle.single, dropCellHeight * 2)
        
        
        var cityCells = [CellElement]()
        var districtCells = [CellElement]()
        
        var areaData:Array = [
            (("city",0),cityCells),
            (("district",0),districtCells)
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
        var array:Array = [
            DropRootView.getDropView(model: ruleModel, delegate: nil),
            DropRootView.getDropView(model: AreaModel, delegate: nil),
            DropRootView.getDropView(model: FeaturesModel, delegate: nil)]
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
        self.addNofication()

        // Do any additional setup after loading the view.
    }    
    
    private func creatUI() {
        self.title = "大厅"
        self.prepareTableView()
        self.prepareHeadView()
        
        let leftItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(didClickLeft(_:)))
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(didClickRight(_:)))
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
    }

    @objc private func didClickLeft(_ item:UIBarButtonItem) {
        //date -> string
        let myFormatter = DateFormatter()
        //这里有很多默认的日期格式
        myFormatter.dateStyle = .long
        //默认的时间格式
        myFormatter.timeStyle = .long
        let string = myFormatter.string(from: Date.init(timeIntervalSinceNow: 0))
        
        NHAlertView.actionShow("发送消息","2,1,"+string, [("取消",.default,{(action) in }),("确定",.default,{(action) in
            var message = LMessage()
            message.data = string.data(using: .utf8)
            LinkManager.shareManager.sendMessage(message)
        })]
        )
    }
    @objc private func didClickRight(_ item:UIBarButtonItem) {
        if item.tag == 101 {
            item.tag = 100
            LinkManager.shareManager.Register()
            self.title = "已链接"
        } else {
            item.tag = 101
            LinkManager.shareManager.Logout()
            self.title = "断开链接"
        }
    }
    
    private func addNofication () {
        
        NotificationCenter.default.addObserver(
            forName: NHNotifyName.AreaUpdated,
            object: nil, queue: OperationQueue.main, using: { (notification) in
                self.resetAreaView()
        })
        NotificationCenter.default.addObserver(
            forName: NHNotifyName.ReceiveMessage,
            object: nil, queue: OperationQueue.main, using: { (notification) in
                
                self.lists.append(notification.object as? String ?? "11" )
                self.tableView.reloadData()
        })
    }
    
    func resetAreaView() {
        if UnEmptyArray(self.dropDownViews) {
            let areaView = self.dropDownViews[1] as! NHAreaView
            areaView.resetAll()
        }
    }
    
    deinit {
        //记得移除通知监听
        NotificationCenter.default.removeObserver(self)
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
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = "receive \(lists[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
    
}

//MARK: HeadView
extension NHHomePageController:NHProvinceDelegate {
    func didSelectProvince(model: CellElement) {
        SystemPreferences().set(String.init(format: "%d", model.code) , forKey: Constants.NOW_PROVINCE_CODE)
        resetAreaView()
        didSelectItem(model: dropDownViews[1].model)
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
        
        self.dropDownViews.forEach({ (view) in
            view.dropDelegate = self
        })
        let dropMenu = YNDropDownMenu(frame: CGRect.init(origin: CGPoint.init(x: self.headView.frame.origin.x, y: kNavigationH), size: self.headView.bounds.size), dropDownViews:self.dropDownViews, dropDownViewTitles: ["推荐", self.location?.rgcData?.city ?? "地区", "要求"])
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

