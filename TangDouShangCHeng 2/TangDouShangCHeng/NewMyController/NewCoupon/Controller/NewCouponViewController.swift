//
//  NewCouponViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/21.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewCouponViewController: BaseTableViewController,NewCouponHeaderDelegate {

    var statesView:NewCouponHeader?
    var searchView:SearchView?
    
    var notUseBtn:UIButton?
    var useedBtn:UIButton?
    var outofDataBtn:UIButton?
    var transformBtn:UIButton?
    
    var flagLabel:UILabel?
    var flagLabelX:CGFloat = 0
    var flagLabelW:CGFloat = 0
    var btnSelectTag = 0
    
    var page = 0
    var type = "a"
    var notUseModels:[CouponModel] = []
    var usedModels:[CouponModel] = []
    var outDataModels:[CouponModel] = []
    var couponModels:[CouponModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "优惠券"
        self.tableView.frame = CGRect(x: 0, y: 50, width: kWidth, height: kHeight-50)
        self.view.backgroundColor = UIColor(fromHexString: "f4f4f4")


        self.tableView.register(UINib(nibName: "NewCouponCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.white
        self.createStatusView()
        self.createHeader()
       
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.setTabelViewRefresh()
    }
    func createHeader() {
        let nib = Bundle.main.loadNibNamed("SearchView", owner: nil, options: nil)
        let view = nib?.first as! SearchView
        view.frame = CGRect(x: 0, y: 5, width: kWidth, height: 150)
        view.getCouponBtn.whenTapped {
           self.getCoupon()
        }
        self.tableView.tableHeaderView = view
        self.searchView = view
    }
    
    func getCoupon() {
        
        if !(Tool.islogin()) {
            Tool.loginWith(animated: true, viewController: nil)
            return
        }
        if self.searchView?.inputTF.text?.count==0 {
            Tool.showPromptContent("请输入兑换码", on: self.view)
            return
        }
        self.searchView?.inputTF.resignFirstResponder()
        weak var weakSelf = self
        HttpHelper.getAddCouponData(withUserID: ShareManager.shareInstance().userinfo.id, coupons_secret: self.searchView?.inputTF.text, success: { (data) in

            let dict = data! as NSDictionary
            let status = dict["status"] as! String
            let desc = dict["desc"] as! String
            if (status == "0"){
                self.setTabelViewRefresh()
            }else{
              Tool.showPromptContent(desc, on: weakSelf?.view)
            }
            
        }) { (error) in
            Tool.showPromptContent("网络出错了", on: weakSelf?.view)
        }

    }
    
    
    
    func createStatusView()  {
        let headeView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 43))

        headeView.backgroundColor = UIColor.white
        flagLabelW = (kWidth-100)/4
        flagLabelX = 20
        let notusebtn = UIButton(frame: CGRect(x: flagLabelX, y: 10, width: flagLabelW, height: 23))
        notusebtn.setTitle("未使用(0)", for: .normal)
        notusebtn.setTitleColor(UIColor.black, for: .normal)
        notusebtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        notusebtn.whenTapped {
            //MARK:点击未使用btn跳转方法
            self.type = "a"
            self.btnSelectTag = 0
            self.selectLabelWith(tag: self.btnSelectTag)
           
        }
        self.notUseBtn = notusebtn
        let label = UILabel(frame: CGRect(x: flagLabelX, y: 42, width: flagLabelW, height: 2))

        label.backgroundColor = UIColor(fromHexString: "E26650")
        headeView.addSubview(label)
        self.flagLabel = label
        headeView.addSubview(notusebtn)
      
        flagLabelX = CGFloat(20*2)+flagLabelW
        
        let useedbtn = UIButton(frame: CGRect(x: flagLabelX, y: 10, width: flagLabelW, height: 23))
        useedbtn.setTitle("已使用(0)", for: .normal)
        useedbtn.setTitleColor(UIColor.black, for: .normal)
        useedbtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        useedbtn.whenTapped {
            //MARK:点击已使用btn跳转方法
            self.type = "b"
            self.btnSelectTag = 1
            self.selectLabelWith(tag: self.btnSelectTag)
           
        }
        self.useedBtn = useedbtn
        headeView.addSubview(useedbtn)
        
        flagLabelX = CGFloat(20*3)+2*flagLabelW
        let outofdatabtn = UIButton(frame: CGRect(x: flagLabelX, y: 10, width: flagLabelW, height: 23))
        outofdatabtn.setTitle("已过期(0)", for: .normal)
        outofdatabtn.setTitleColor(UIColor.black, for: .normal)
        outofdatabtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        outofdatabtn.whenTapped {
            //MARK:点击已过期btn跳转方法
            self.type = "b"
            self.btnSelectTag = 2
            self.selectLabelWith(tag: self.btnSelectTag)
        }
        self.outofDataBtn = outofdatabtn
        headeView.addSubview(outofdatabtn)
        flagLabelX = CGFloat(20*4)+3*flagLabelW
        let transformbtn = UIButton(frame: CGRect(x: flagLabelX, y: 10, width: flagLabelW, height: 23))
        transformbtn.setTitle("转让(0)", for: .normal)
        transformbtn.setTitleColor(UIColor.black, for: .normal)
        transformbtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        transformbtn.whenTapped {
            //MARK:点击已转让btn跳转方法
            self.type = "a"
            self.btnSelectTag = 3
            self.selectLabelWith(tag: self.btnSelectTag)
        }
        self.transformBtn = transformbtn
        headeView.addSubview(transformbtn)
        
        self.view.addSubview(headeView)

    }
    
    func getCouponListData() {
        if !Tool.islogin() {
            Tool.showPromptContent("请登陆")
            return
        }
        HttpHelper.getCouponListData(withUserID: ShareManager.shareInstance().userinfo.id, pageNum: "\(page)", limitNum: "20", type: self.type, success: { (reDict) in
            self.hideRefresh()
            let dict = reDict! as NSDictionary
            self.handleloadListResult(dict: dict)
            
            
        }) { (error) in
            self.hideRefresh()
            Tool.showPromptContent(error, on: self.view)
        }
    }
    
    func handleloadListResult(dict:NSDictionary) {
        let dic = dict["data"] as! NSDictionary
       print("handleloadListResult",dic)
        var couponArr:NSArray? = nil
        
        if (dic["couponsList"] as? NSArray) == nil{
            couponArr = []
            print("fuck!!!!")
        }else{
             print("why!!!!")
            couponArr = dic["couponsList"] as? NSArray
        }
        
        if (couponArr?.count)!>0{
            if self.couponModels.count>0&&page == 1{
                couponModels.removeAll()
                if self.type == "a"{
                    notUseModels.removeAll()
                    
                }else{
                    usedModels.removeAll()
                    outDataModels.removeAll()
                }
                
            }
            
            for dic in couponArr!{
                let couponDict = dic as! NSDictionary
                let model = couponDict.object(by: CouponModel.self) as! CouponModel
                
                if model.status == "未使用"{
                    self.notUseModels.append(model)
                }
                
                if model.status == "已使用"||model.status == "转让中"{
                    self.usedModels.append(model)
                    
                }
                
                if model.status == "已过期"{
                    self.outDataModels.append(model)
                    
                }
                
                couponModels.append(model)
                
            }
        }
        self.notUseBtn?.setTitle("未使用(\(notUseModels.count))", for: .normal)
        self.useedBtn?.setTitle("已使用(\(usedModels.count))", for: .normal)
        self.outofDataBtn?.setTitle("已过期(\(outDataModels.count))", for: .normal)
        self.transformBtn?.setTitle("转让(\(notUseModels.count))", for: .normal)
        
        
        page+=1
        self.tableView.reloadData()
    }
    
    func delete(arr:NSArray)  {
        
        
        
    }
    
    //    MARK: - 上下刷新
    func setTabelViewRefresh() {
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
           
            weakSelf?.getCouponListData()
        })
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        weakSelf?.tableView.mj_header.isAutomaticallyChangeAlpha = true
        weakSelf?.tableView.mj_header.beginRefreshing()
        //        上拉刷新
        weakSelf?.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            weakSelf?.getCouponListData()
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

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       var num = 0
        switch btnSelectTag {
        case 0:
            num = notUseModels.count
        case 1:
            num = usedModels.count
        case 2:
            num = outDataModels.count
        case 3:
            num = notUseModels.count
        default:
            num = 0
        }
       
        return num
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewCouponCell
        cell.selectionStyle = .none
        if self.btnSelectTag == 0 {
            cell.rightBtn.setTitle("立即使用", for: .normal)
            cell.leftImageView.image = UIImage(named: "cell_left")
            cell.rightImageView.image = UIImage(named:"cell_right")
            cell.couponModel = notUseModels[indexPath.row]
            cell.rightBtn.whenTapped {
                let model = self.notUseModels[indexPath.row].setHomeGoodMode()
                let vc = GoodDetailViewController(tableViewStyle: .plain)
                vc?.goodModel = model
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            cell.falgeImageView.isHidden = true
        }
        if self.btnSelectTag == 1 {
            cell.rightBtn.setTitle("已使用", for: .normal)
            cell.leftImageView.image = UIImage(named: "cell_useLeft")
            cell.rightImageView.image = UIImage(named:"cell_useRight")
            cell.couponModel = usedModels[indexPath.row]
            cell.falgeImageView.isHidden = false
            cell.falgeImageView.image = UIImage(named: "useed")
        }
        if self.btnSelectTag == 2 {
            cell.rightBtn.setTitle("已过期", for: .normal)
            cell.leftImageView.image = UIImage(named: "cell_useLeft")
            cell.rightImageView.image = UIImage(named:"cell_useRight")
            cell.falgeImageView.isHidden = false
            cell.couponModel = outDataModels[indexPath.row]
            cell.falgeImageView.image = UIImage(named: "outOfData")
        }
        if self.btnSelectTag == 3 {
            cell.rightBtn.setTitle("立即转让", for: .normal)
            cell.rightBtn.whenTapped({
                 if self.btnSelectTag == 3 {
                let model = self.notUseModels[indexPath.row]
                let gmodel = model.setHomeGoodMode()
                let vc = NewShopShareCouponViewController()
                vc.goodModel = gmodel
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            cell.leftImageView.image = UIImage(named: "cell_left")
            cell.rightImageView.image = UIImage(named:"cell_right")
            cell.falgeImageView.isHidden = true
            cell.couponModel = notUseModels[indexPath.row]
        }
        
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.btnSelectTag == 1||self.btnSelectTag == 2 {
            
        }else{
//            var model = CouponModel()
//            if self.btnSelectTag == 0 {
//                model = notUseModels[indexPath.row]
//            }
//            
//            if self.btnSelectTag == 1 {
//                model = usedModels[indexPath.row]
//            }
//            
//            if self.btnSelectTag == 2 {
//                model = outDataModels[indexPath.row]
//            }
//            
//            if self.btnSelectTag == 3 {
//                model = notUseModels[indexPath.row]
//            }
//
//            let gmodel = model.setHomeGoodMode()
//            let vc = NewShopShareCouponViewController()
//            vc.goodModel = gmodel
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        if self.btnSelectTag == 0 {
            view.rightLabel.text = "使用规则"
        }
        if self.btnSelectTag == 1 {
            view.rightLabel.text = "使用规则"
        }
        if self.btnSelectTag == 2 {
            view.rightLabel.text = "使用规则"
        }
        if self.btnSelectTag == 3 {
            view.rightLabel.text = "转让规则"
        }
        view.rightLabel.textColor = UIColor.black
        view.rightLabel.font = UIFont.systemFont(ofSize: 12)
        view.leftLabel.text = ""
        view.whenTapped {
            if self.btnSelectTag != 3 {
                let vc = NewCouponRulerViewController()
                vc.titleStr = "使用规则"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = NewCouponRulerViewController()
                vc.titleStr = " 转让规则"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return view
    }
    
    
    //cell动画
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
//        UIView.animate(withDuration: 1, animations: {
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
//            
//        })
//    }
    
    
    func selectLabelWith(tag: Int) {
        self.tableView.contentOffset = CGPoint(x: 0, y: 0)
        
        let x = CGFloat(20)+(20+flagLabelW)*CGFloat(tag)
        UIView.animate(withDuration: 0.1, animations: {
            self.flagLabel?.frame = CGRect(x: x, y: 42, width: self.flagLabelW, height: 2)
        }, completion: nil)
        
        //        MARK:获取网络数据然后刷新请求
        self.setTabelViewRefresh()
        
    
        
        
    }
    

}
