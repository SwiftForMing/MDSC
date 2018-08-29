//
//  NewShopMyViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/20.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopMyViewController: BaseTableViewController {

    var headerView:NewMyHeaderView?
    var orderCell:MyOrderCell?
    var couponNum = 0
    var scoreText = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = UIColor.red
        self.navigationController?.isNavigationBarHidden = true
        if Tool.islogin() {
             headerView?.userInfo = ShareManager.shareInstance().userinfo
            self.getScoreList()
        }
       

        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
         UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ty:CGFloat = 0
        if kHeight == 812.0 {
            ty = -44
        }else{
            ty = -20
        }
        
        tableView.frame = CGRect(x: 0, y: ty, width: kWidth, height: kHeight)
        let nib = Bundle.main.loadNibNamed("NewMyHeaderView", owner: nil, options: nil)
        let header = nib?.first as! NewMyHeaderView
        header.frame = CGRect(x: 0, y: 0, width: kWidth, height: 180)
        header.userInfo = ShareManager.shareInstance().userinfo
        header.settingBtn.whenTapped {
            if !Tool.islogin(){
                Tool.loginWith(animated: true, viewController: nil)
            }else{
                let vc = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.buyCouponBtn.whenTapped {
//            let vc = NewBuyCouponViewController(nibName: "NewBuyCouponViewController", bundle: nil)
//            vc.view.backgroundColor = UIColor.clear
//            //设置model的样式
//            vc.modalPresentationStyle = .custom
//            vc.delegate = self
//            let rootVC = UIApplication.shared.keyWindow?.rootViewController
//            rootVC?.present(vc, animated: true, completion: nil)
        }
        
        header.changeBtn.whenTapped {
//            let vc = NewChangeViewController(tableViewStyle: .plain)
//            self.navigationController?.pushViewController(vc!, animated: true)
            
            let vc = MallCollectionViewController(nibName:"MallCollectionViewController", bundle: nil)
            self.navigationController?.hh_pushViewController(vc, style:AnimationStyleRippleEffect)

        }
        
        header.userHeader.whenTapped {
            if !Tool.islogin(){
                Tool.loginWith(animated: true, viewController: nil)
            }else{
                let vc = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.tableView.tableHeaderView = header
        self.headerView = header
        
        self.tableView.register(UINib(nibName: "MyNewIconCell", bundle: nil), forCellReuseIdentifier: "iconCell")
        self.tableView.register(UINib(nibName: "MyOrderTitleCell", bundle: nil), forCellReuseIdentifier: "orderTitleCell")
        self.tableView.register(UINib(nibName: "MyOrderCell", bundle: nil), forCellReuseIdentifier: "orderCell")
         self.tableView.register(UINib(nibName: "NewMyListCell", bundle: nil), forCellReuseIdentifier: "listCell")

    }
    
    func goCouponcenter(price: String) {
//        let vc = CouponCenterViewController(nibName: "CouponCenterViewController", bundle: nil)
//        vc.couponPrice = price
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getOrderCount() {
        if !Tool.islogin() {
            if ShareManager.shareInstance().isInReview {
                
            }else{

                Tool.autoLoginSuccess({ (data) in
                    if String(describing: (data! as NSDictionary)["status"]) == "0"{
                        self.getOrderCount()
                    }
                }, fail: { (error) in

                })
            }
            return
        }else{
//        HttpHelper.getOrderCount(withUserID: ShareManager.shareInstance().userinfo.id, success: { (data) in
//            let dict = data! as NSDictionary
//           
//            let status = dict["status"] as! String
//            if status == "0"{
//                let dic = dict["data"] as! NSDictionary
//                let model = dic.object(by: OrderCountModel.self) as! OrderCountModel
//                if (self.orderCell != nil){
//                    self.orderCell?.getNumWith(orderCountModel: model)
//                }
//            }
//        }) { (error) in
//            Tool.showPromptContent(error!)
//            }
        }
    }
    
//    func getCouponListData() {
//        if !Tool.islogin() {
//            Tool.showPromptContent("请登陆")
//            return
//        }
//        HttpHelper.getCouponListData(withUserID: ShareManager.shareInstance().userinfo.id, pageNum: "1", limitNum: "0", type: "a", success: { (reDict) in
//
//            let dict = reDict! as NSDictionary
//            self.handleloadListResult(dict: dict)
//
//
//        }) { (error) in
////            self.hideRefresh()
//            Tool.showPromptContent(error, on: self.view)
//        }
//    }
//
//    func handleloadListResult(dict:NSDictionary) {
//        let dic = dict["data"] as! NSDictionary
//
//        var couponArr:NSArray? = nil
//
//        if dic["couponsList"] != nil {
//            couponArr = dic["couponsList"] as? NSArray
//        }else{
//            couponArr = []
//        }
////        print("couponArr",couponArr?.count)
//        self.couponNum = (couponArr?.count)!
//         self.tableView.reloadData()
//    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return 2
        }
        
        if section == 2 {
            if(ShareManager.shareInstance().isInReview){
                return 2
            }else{
              return 4
            }
        }else{
            return 0
        }
        
    }
    
    func getScoreList() {
        
        HttpHelper.getScoreList(withID: ShareManager.shareInstance().userinfo.id, success: { (data) in
            let dict = data! as NSDictionary
            let arr = dict["data"] as! NSArray
            if (arr.count>0){
                let dic = arr.firstObject as! NSDictionary
                let score = dic["get_score"] as! NSNumber
                self.scoreText = "最新获得馈赠 \(score)欢乐豆"
            }
           
            
        }) { (error) in
            self.scoreText  = ""
        }
      self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath) as! MyNewIconCell
            
            if Tool.islogin(){
             cell.couponNunLabel.text = "\(Int(ShareManager.shareInstance().userinfo.user_money))"
             cell.collectNumLabel.text = "\(DataManager().fetchAllData().count)"
             cell.beanNumLabel.text = "\(ShareManager.shareInstance().userinfo.user_score)"
             cell.newGetLabel.text = self.scoreText
            }
            
            cell.collectView.whenTapped({
                let vc = NewShopCollectViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
            cell.beanView.whenTapped({
                let vc = ChangeJiFenViewController(nibName: "ChangeJiFenViewController", bundle: nil)
                vc.changeType = "score"
                self.navigationController?.hh_pushViewController(vc, style: AnimationStyleRippleEffect)
            })
            cell.selectionStyle = .none
            return cell
        }
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0{
               let cell = tableView.dequeueReusableCell(withIdentifier: "orderTitleCell", for: indexPath) as! MyOrderTitleCell
                cell.selectionStyle = .none
               return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! MyOrderCell
                self.orderCell = cell
                cell.waitPayView.whenTapped({
                    if(Tool.islogin()){
                        let vc = NewShopMyOrderViewController(tableViewStyle: .grouped)
                        vc?.btnSelectTag = 1
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
                        Tool.showPromptContent("请先登录")
                    }
                   
                })
                
                cell.waitSendView.whenTapped({
                    if(Tool.islogin()){
                        let vc = NewShopMyOrderViewController(tableViewStyle: .grouped)
                        vc?.btnSelectTag = 2
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
                        Tool.showPromptContent("请先登录")
                    }
                })
                
                cell.sendView.whenTapped({
                    if(Tool.islogin()){
                        let vc = NewShopMyOrderViewController(tableViewStyle: .grouped)
                        vc?.btnSelectTag = 3
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
                        Tool.showPromptContent("请先登录")
                    }
                })
                
                cell.commentView.whenTapped({
                    if(Tool.islogin()){
                        let vc = NewShopMyOrderViewController(tableViewStyle: .grouped)
                        vc?.btnSelectTag = 4
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
                        Tool.showPromptContent("请先登录")
                    }
                })
                
                cell.kfView.whenTapped({
//                    self.gotoKF()                 
                    if(Tool.islogin()){
                        let vc = SclesViewController(tableViewStyle: .grouped)
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
                        Tool.showPromptContent("请先登录")
                    }
                   
                })
                cell.selectionStyle = .none
                return cell
            }
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! NewMyListCell
            cell.selectionStyle = .none
            if indexPath.row == 2{
                    cell.leftImageView.image = UIImage(named: "credit-card")
                    cell.titleLabel.text = "转让小米"
            }
            if indexPath.row == 3{
                cell.leftImageView.image = UIImage(named: "credit-card")
                cell.titleLabel.text = "转让商品"
            }
            if indexPath.row == 0{
                cell.leftImageView.image = UIImage(named: "pin-3")
                cell.titleLabel.text = "地址管理"
            }
            if indexPath.row == 1{
                cell.leftImageView.image = UIImage(named: "headphones")
                cell.titleLabel.text = "联系客服"
            }
            return cell
        }
        
        let cell = UITableViewCell()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 2{
                let vc = ChangeJiFenViewController(nibName: "ChangeJiFenViewController", bundle: nil)
                self.navigationController?.hh_pushViewController(vc, style: AnimationStyleRippleEffect)
               
            }
            if indexPath.row == 3{
                let vc = GetGoodListViewController()
                self.navigationController?.hh_pushViewController(vc, style: AnimationStyleRippleEffect)
            }
            
            if indexPath.row == 0{
               let vc = ReciverAddressViewController()
                vc.isSelectAddress = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if indexPath.row == 1{
                self.gotoKF()
            }
        }
//        if indexPath.section == 1{
//           let vc = NewShopMyOrderViewController(tableViewStyle: .grouped)
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
    }

   
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 50
            }else{
                return 88
            }
        }
        
        if indexPath.section == 2 {
            return 50
        }else{
            
            return 44
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 10))
        footerView.backgroundColor = UIColor(fromHexString: "F8F6F6")
        footerView.alpha = 0.7
        return footerView
    }
    

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
         return 0.01
        }else{
         return 10
        }
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
        back.image = UIImage(named: "new_back")
        leftItemControl.addSubview(back)
        chatViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemControl)
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    //    MARK: - 上下刷新
    func setTabelViewRefresh() {
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//            self.page = 1
            weakSelf?.getOrderCount()
            weakSelf?.tableView.reloadData()
            
        })
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        weakSelf?.tableView.mj_header.isAutomaticallyChangeAlpha = true
        weakSelf?.tableView.mj_header.beginRefreshing()
        //        上拉刷新
        weakSelf?.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//            weakSelf?.getData()
        })
//        weakSelf?.tableView.mj_footer.isAutomaticallyHidden = true
        
    }
    
    func hideRefresh() {
        if self.tableView.mj_footer.isRefreshing {
            self.tableView.mj_footer.endRefreshing()
        }
        if self.tableView.mj_header.isRefreshing {
            self.tableView.mj_header.endRefreshing()
        }
        
    }
    
}
