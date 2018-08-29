//
//  NewUserViewController.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/7/20.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class NewUserViewController: UITableViewController {
        
    @IBOutlet weak var rulerBtn: UIButton!
    @IBOutlet weak var getScoreLabel: UILabel!
    @IBOutlet weak var beansLabel: UILabel!
    @IBOutlet var NewUserHeader: UIView!
    
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var liftValueLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var goPayBtn: UIButton!
    
    @IBOutlet weak var moneyView: UIView!
    
    @IBOutlet weak var djxImageView: UIImageView!
    
    @IBOutlet weak var dfhImageView: UIImageView!
    @IBOutlet weak var yjxImageView: UIImageView!
    
    @IBOutlet weak var yfhImageView: UIImageView!
    
    @IBOutlet weak var wdhImageView: UIImageView!
    
    
    @IBOutlet weak var zrxmImageView: UIImageView!
    
    @IBOutlet weak var zrspImageView: UIImageView!
    
    @IBOutlet weak var zxkfImageView: UIImageView!
    
    @IBOutlet weak var shdzImageView: UIImageView!
    
    @IBOutlet weak var mdscImageView: UIImageView!
    @IBOutlet weak var zrhldImageView: UIImageView!
    
    var lift:String?{
        didSet{
            let liftValue = String(lift!)!
            let liftInt = Double(liftValue)!
            self.liftValueLabel.text = String(format:"%.2f", (Double(liftInt)))
            self.liftLabel.text = String(format:"%.2f", (Double(liftInt)/10))+"%"
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.frame = CGRect(x: 0, y: -20, width: kWidth, height: kHeight)
        NewUserHeader.width *= kWidth/375.0
        NewUserHeader.height *= kWidth/375.0
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.layer.masksToBounds = true
        goPayBtn.layer.masksToBounds = true
        goPayBtn.layer.cornerRadius = goPayBtn.frame.height/2
        goPayBtn.layer.borderColor = UIColor.red.cgColor
        goPayBtn.layer.borderWidth = 1
        moneyView.layer.masksToBounds = true
        moneyView.layer.cornerRadius = 5
        
        goPayBtn.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = EntBuyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        
        dfhImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = DuoBaoRecordViewController(nibName: "DuoBaoRecordViewController", bundle: nil)
            vc.type = "myvc"
            vc.flag = "1"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        yjxImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = DuoBaoRecordViewController(nibName: "DuoBaoRecordViewController", bundle: nil)
            vc.type = "myvc"
            vc.flag = "2"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        djxImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = DuoBaoRecordViewController(nibName: "DuoBaoRecordViewController", bundle: nil)
            vc.type = "myvc"
            vc.flag = "1"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        yfhImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = DuoBaoRecordViewController(nibName: "DuoBaoRecordViewController", bundle: nil)
            vc.type = "myvc"
            vc.flag = "2"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        wdhImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = ZJRecordViewController(nibName: "ZJRecordViewController", bundle: nil)
            vc.is_happybean_goods = "0"
            vc.title = "中奖记录"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        zrxmImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
           let vc = ChangeJiFenViewController(nibName: "ChangeJiFenViewController", bundle: nil)
           self.navigationController?.pushViewController(vc, animated: true)
        }
        
        zrhldImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = ChangeJiFenViewController(nibName: "ChangeJiFenViewController", bundle: nil)
            vc.changeType = "score"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        zrspImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = GetGoodListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        zxkfImageView.whenTapped {
            self.gotoKF()
        }
        mdscImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = MallCollectionViewController(nibName: "MallCollectionViewController", bundle: nil)
//            vc.isSelectAddress = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        shdzImageView.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = ReciverAddressViewController()
            vc.isSelectAddress = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        userImageView.whenTapped {
            if (Tool.islogin()){
                self.goUserInfo()
            }else{
                self.loginClick()
            }
        }
        
        rulerBtn.whenTapped {
            if (!Tool.islogin()){
                self.loginClick()
                return
            }
            let vc = NewCouponRulerViewController()
            vc.titleStr = "使用规则"
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        self.tableView.tableHeaderView = NewUserHeader
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
        chatViewConfig?.customizedId = userID
        chatViewConfig?.enableEvaluationButton = false
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
    
    func goUserInfo() {
        if (!Tool.islogin()) {
           Tool.loginWith(animated: true, viewController: nil)
            return
        }
        let vc = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginClick() {
        Tool.loginWith(animated: true, viewController: nil)
    }
    
    
    func getLiftData(){
        HttpHelper.getCurrentLiftInfo(withUserId: ShareManager.shareInstance().userinfo.id, success: { (data) in
            let dict = data! as NSDictionary
            print("getCurrentLiftInfo",dict)
            let status = dict["status"] as! String
            if status == "0" {
                let dic = dict["data"] as! NSDictionary
                let lift = dic["CurrentLift"] as! String
                self.lift = lift
            }else{
                Tool.showPromptContent("未签到")
            }
            
        }) { (error) in
            Tool.showPromptContent(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Tool.islogin() {
            
            Tool.getUserInfo()
            self.getLiftData()
            if(ShareManager.shareInstance().userinfo.user_header != nil){
                userImageView.sd_setImage(with: URL(string: ShareManager.shareInstance().userinfo.user_header), placeholderImage: UIImage(named: ""))
            }
            loginLabel.text = ShareManager.shareInstance().userinfo.nick_name
            moneyLabel.text = "\(ShareManager.shareInstance().userinfo.user_money)"
            beansLabel.text = "\(ShareManager.shareInstance().userinfo.user_score)"
            self.getScoreList()
        }else{
            userImageView.image = UIImage(named: "avatar_header")
            loginLabel.text = "未登陆"
            moneyLabel.text = "0"
            beansLabel.text = "0"
            getScoreLabel.text = ""
        }
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = false
        
        
    }
    // MARK: - Table view data source

    func getScoreList() {
        HttpHelper.getScoreList(withID: ShareManager.shareInstance().userinfo.id, success: { (data) in
            let dict = data! as NSDictionary
            let arr = dict["data"] as! NSArray
            if(arr.count>0){
                let dic = arr[0] as! NSDictionary
                let score = dic["get_score"] as! NSNumber
                self.getScoreLabel.text = "最新+\(score)欢乐豆"
            }
            
        }) { (error) in
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

  
}
