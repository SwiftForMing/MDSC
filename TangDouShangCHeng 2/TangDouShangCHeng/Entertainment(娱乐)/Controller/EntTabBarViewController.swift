//
//  EntTabBarViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/10/26.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit
@objc protocol ChangeDelegate{
    func changeVC(isMK:Bool)
}

@objc(EntTabBarViewController)
class EntTabBarViewController: UITabBarController{
    var vcdelegate:ChangeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
//        let leftControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
//        leftControl.addTarget(self, action: #selector(back), for: .touchUpInside)
//        let imageView  = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
//        imageView.image = UIImage(named: "new_back")
//        leftControl.addSubview(imageView)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftControl)
//
//        let rightControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
//        rightControl.addTarget(self, action: #selector(gotoKF), for: .touchUpInside)
//        let label  = UILabel(frame: CGRect(x: 0, y: 13, width: 40, height: 18))
//        label.text = "客服"
//        label.textColor = UIColor.white
//        rightControl.addSubview(label)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightControl)
        
        
        self.createTabBar()

    }
    
        func gotoKF() {
    
            if !Tool.islogin() {
                Tool.loginWith(animated: true, viewController: nil)
                return
            }
    
            let userInfo = ShareManager.shareInstance().userinfo
            let userID = userInfo?.id
    
            let version = (Bundle.main.infoDictionary! as NSDictionary).object(forKey: "CFBundleShortVersionString") as! String
            let versionString = "iOS \(version)"
            let alias = userInfo?.nick_name
            let telephone = userInfo?.user_tel
    
            let chatViewConfig = MQChatViewConfig.shared()
            let chatViewController = MQChatViewController(chatViewManager: chatViewConfig)
            chatViewConfig?.enableOutgoingAvatar = false
            chatViewConfig?.enableRoundAvatar = true
            chatViewConfig?.navTitleColor = UIColor.white
            chatViewConfig?.navBarColor = UIColor.white
            chatViewConfig?.statusBarStyle = .lightContent
//            chatViewController!.title = "客服"
//            chatViewConfig?.navTitleText = "客服"
            chatViewConfig?.customizedId = userID
            chatViewConfig?.enableEvaluationButton = false
//            chatViewConfig?.agentName = "客服"
            chatViewConfig?.clientInfo = ["name":alias!,"version": versionString,"identify": userID!,"telephone": telephone!]
            chatViewConfig?.updateClientInfoUseOverride = true
            chatViewConfig?.recordMode = .duckOther
            chatViewConfig?.playMode = .mixWithOther
            self.navigationController?.pushViewController(chatViewController!, animated: true)
            let leftItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
            leftItemControl.addTarget(self, action: #selector(self.back), for: .touchUpInside)
            let back = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
            back.image = UIImage(named: "new_back")
            leftItemControl.addSubview(back)
            chatViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemControl)
        }
    
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "5ad485")
        self.navigationController?.navigationBar.isHidden = true
         ShareManager.shareInstance().isInYlc = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor.defaultRed()
        self.navigationController?.navigationBar.isHidden = true
        ShareManager.shareInstance().isInYlc = true
    }
    func createTabBar() {
        let entHomeVC = HomePageViewController(nibName: "HomePageViewController", bundle: nil)
//        entHomeVC.changeBlock = { b in
//            self.vcdelegate?.changeVC(isMK: b)
//            self.back()
//        }
        
        
        let jiexiaoVC = JieXiaoViewController(nibName: "JieXiaoViewController", bundle: nil)
        let qiandaoVC = NewCalerderViewController(nibName: "NewCalerderViewController", bundle: nil)
        let shopVC = ShoppingCarVC()
        let myVC = NewUserViewController(nibName: "NewUserViewController", bundle: nil)
        
        let jiexiaoNav =  BaseNavViewController(rootViewController: jiexiaoVC)
        let qiandaoNav =  BaseNavViewController(rootViewController: qiandaoVC)
        let shopNav =  BaseNavViewController(rootViewController: shopVC)
        let entHomeNav =  BaseNavViewController(rootViewController: entHomeVC)
        let myNav =  BaseNavViewController(rootViewController: myVC)
        
        let vcArr = [entHomeNav,jiexiaoNav,qiandaoNav,myNav]
        
       
        self.tabBar.tintColor = UIColor.red
        self.tabBar.backgroundColor = UIColor.white
        var tabBarImageNameNormal = "tab_index"
        var tabBarImageNameSelected = "tab_index_selected"
        var title = "时时彩专区"
        if(ShareManager.shareInstance().isEnterMK) {
            
            title = "秒开专区"
        }
        
             self.title = title
       
        var tabBarItem = UITabBarItem(title: title, image: UIImage(named: tabBarImageNameNormal), selectedImage: UIImage(named: tabBarImageNameSelected))
        entHomeNav.tabBarItem = tabBarItem
        
        tabBarImageNameNormal = "tab_new"
        tabBarImageNameSelected = "tab_new_selected"
        title = "揭晓"
        tabBarItem = UITabBarItem(title: title, image: UIImage(named: tabBarImageNameNormal), selectedImage: UIImage(named: tabBarImageNameSelected))
        jiexiaoNav.tabBarItem = tabBarItem
        
        
//        NewCalerderViewController *Calerdervc = [[NewCalerderViewController alloc]initWithNibName:@"NewCalerderViewController" bundle:nil];
//        BaseNavViewController *calerNav = [[BaseNavViewController alloc] initWithRootViewController:Calerdervc];
//        tabBarImageNameNormal = @"tab_index";
//        tabBarImageNameSelected = @"tab_index_selected";
//        title = @"签到";
//        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
//        tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
//        Calerdervc.tabBarItem = tabBarItem;
        
        tabBarImageNameNormal = "tab_index"
        tabBarImageNameSelected = "tab_index_selected"
        title = "签到"
        tabBarItem = UITabBarItem(title: title, image: UIImage(named: tabBarImageNameNormal), selectedImage: UIImage(named: tabBarImageNameSelected))
        qiandaoNav.tabBarItem = tabBarItem
        
        tabBarImageNameNormal = "tab_shop"
        tabBarImageNameSelected = "tab_shop_selected"
        title = "购物车"
        tabBarItem = UITabBarItem(title: title, image: UIImage(named: tabBarImageNameNormal), selectedImage: UIImage(named: tabBarImageNameSelected))
        shopNav.tabBarItem = tabBarItem
        
        tabBarImageNameNormal = "tab_me"
        tabBarImageNameSelected = "tab_me_selected"
        title = "我的"
        tabBarItem = UITabBarItem(title: title, image: UIImage(named: tabBarImageNameNormal), selectedImage: UIImage(named: tabBarImageNameSelected))
        myNav.tabBarItem = tabBarItem
        
         self.viewControllers = vcArr
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "时时彩专区" {
            if(ShareManager.shareInstance().isEnterMK) {
                self.title = "秒开专区"
            }else{
                self.title = item.title
            }
        }else{
             self.title = item.title
        }
       
        print("item.title"+item.title!)
    }
    

}
