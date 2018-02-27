//
//  ZBDropDownMenu.swift
//  Child
//
//  Created by Noah on 2018. 2. 27..
//  Copyright © 2018年 Noah. All rights reserved.
//

import UIKit
import YNDropDownMenu

class NHSortRuleView: YNDropDownView {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func dropDownViewOpened() {
        
    }
    
    override func dropDownViewClosed() {
        
    }
}

class NHAreaView: YNDropDownView {
    
    @IBAction func didClickReset(_ sender: Any) {
        
    }
    
    @IBAction func didClickDone(_ sender: Any) {
        
    }
    
    @IBAction func didClickChangeCity(_ sender: UIButton) {
    }
}

class NHFeaturesView: YNDropDownView {
    @IBAction func didClickReset(_ sender: Any) {
        
    }
    
    @IBAction func didClickDone(_ sender: Any) {
        
    }

}
