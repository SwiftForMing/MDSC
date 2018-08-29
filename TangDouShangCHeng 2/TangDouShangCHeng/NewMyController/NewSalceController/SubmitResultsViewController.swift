//
//  SubmitResultsViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/3/6.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class SubmitResultsViewController: UIViewController {
    @IBOutlet weak var headeImageView: UIImageView!
    var stautes = ""
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var kfBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kfBtn.layer.masksToBounds = true
        kfBtn.layer.cornerRadius = 4
        kfBtn.layer.borderWidth = 1
        kfBtn.layer.borderColor = UIColor(fromHexString: "999999").cgColor
        self.typeLabel.text = stautes
        self.timeLabel.text = Tool.getCurrentTime()
        kfBtn.whenTapped {
            self.gotoKF()
        }
        homeBtn.layer.masksToBounds = true
        homeBtn.layer.cornerRadius = 4
        homeBtn.layer.borderWidth = 1
        homeBtn.layer.borderColor = UIColor(fromHexString: "999999").cgColor
        
        homeBtn.whenTapped {
           let nav = BaseTabBarViewController()
            UIApplication.shared.keyWindow?.rootViewController = nil
            UIApplication.shared.keyWindow?.rootViewController = nav

        }
        
        self.title = "提交成功"
        let leftControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        leftControl.addTarget(self, action: #selector(back), for: .touchUpInside)
        let imageView  = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        imageView.image = UIImage(named: "shopBack")
        leftControl.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftControl)
        // Do any additional setup after loading the view.
    }

    func gotoKF() {
        
        if !ShareManager.shareInstance().userinfo.islogin {
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
        chatViewController!.title = "客服"
        chatViewConfig?.navTitleText = "客服"
        chatViewConfig?.customizedId = userID
        chatViewConfig?.enableEvaluationButton = false
        chatViewConfig?.agentName = "客服"
        chatViewConfig?.clientInfo = ["name":alias!,"version": versionString,"identify": userID!,"telephone": telephone!]
        chatViewConfig?.updateClientInfoUseOverride = true
        chatViewConfig?.recordMode = .duckOther
        chatViewConfig?.playMode = .mixWithOther
        self.navigationController?.pushViewController(chatViewController!, animated: true)
        
        let leftItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        leftItemControl.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        let back = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        back.image = UIImage(named: "shopBack")
        leftItemControl.addSubview(back)
        chatViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemControl)
    }
    
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

}
