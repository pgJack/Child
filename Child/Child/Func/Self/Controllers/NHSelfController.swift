//
//  NHSelfController.swift
//  Child
//
//  Created by Noah on 2018/3/8.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHSelfController: NHTableViewController {

    let headImageView = UIImageView(image:UIImage.init(named: "self_header"))
    let headHeight:CGFloat = 200.0
    var nowNav: NHNavigationController?
    let maxAlphaOffset:CGFloat = 100.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowNav = AppDelegate.nowNavController()
        
        self.title = "我的"
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            // Fallback on earlier versions
        }
        
        let btn:UIButton = UIButton()
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didClickTest), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect.init(x: 0, y: 100, width: 100, height: 100)
        headImageView.frame = CGRect.init(x: 0, y: -headHeight, width: kSCREEN_WIDTH, height: headHeight)
        headImageView.addSubview(btn)
        headImageView.isUserInteractionEnabled = true
        self.tableView.addSubview(headImageView)
        self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0)

        // Do any additional setup after loading the view.
    }
    @objc func didClickTest() {
        print("OKOKOKOKOKOK")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowNav?.NoColorNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        tableView.contentOffset = CGPoint.init(x: 0, y: maxAlphaOffset);
//        scrollViewDidScroll(tableView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nowNav?.ColorNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let offset = scrollView.contentOffset.y;
//        var alpha = (offset + CGFloat(headHeight)) / maxAlphaOffset;
//        if alpha < 0 {alpha = 0.0}
//        if alpha > 1 {alpha = 1.0}
//        nowNav!.alphaView?.alpha = alpha;
//
//        //判断是否改变
//        if (offset < -200) {
//            var rect = headImageView.frame;
//            //我们只需要改变图片的y值和高度即可
//            rect.origin.y = offset;
//            rect.size.height = -offset;
//            headImageView.frame = rect;
//        }
//
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            NHLoginController.SignOut()
            return
        } else if indexPath.section == 1 {
            navigationController?.pushViewController(NHLoginController.init(true), animated: true)
            return
        }
        if !NHUser.Logined() {
            navigationController?.pushViewController(NHLoginController.init(false), animated: true)
        }
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
