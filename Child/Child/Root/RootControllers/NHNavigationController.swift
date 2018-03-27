//
//  NHNavigationController.swift
//  Child
//
//  Created by Noah on 2018/2/24.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHNavigationController: UINavigationController {

    var alphaView:UIView?
    func NoColorNav() {
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    func ColorNav() {
        navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.shadowImage = UIImage()
        alphaView = navigationBar.subviews.first
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super .pushViewController(viewController, animated: animated)
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
